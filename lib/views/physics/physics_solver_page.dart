import 'package:flutter/material.dart';

import '../../controllers/solver_engine.dart';
import '../../models/formula.dart';
import '../../models/physics/formula_database.dart';
import '../../models/physics/hsc_physics1_database.dart';
import '../../models/physics/hsc_physics2_database.dart';
import '../../widgets/physics_keypad.dart';
import 'physics_solution_page.dart';

class PhysicsSolverPage extends StatefulWidget {
  final String categoryName;
  final List<Formula> allFormulas;

  const PhysicsSolverPage({
    super.key,
    required this.categoryName,
    required this.allFormulas,
  });

  @override
  State<PhysicsSolverPage> createState() => _PhysicsSolverPageState();
}

class _PhysicsSolverPageState extends State<PhysicsSolverPage> {
  late List<Formula> _categoryFormulas;

  String? _targetVariable;
  final Map<String, String> _values = {};
  String? _editingVariable;

  @override
  void initState() {
    super.initState();
    _categoryFormulas = _filterByCategory(
      widget.allFormulas,
      widget.categoryName,
    );
  }

  List<Formula> _filterByCategory(List<Formula> formulas, String category) {
    if (category == 'All Topics') return formulas;
    final filtered = formulas
        .where((f) => f.category.toLowerCase() == category.toLowerCase())
        .toList();
    return filtered.isEmpty ? formulas : filtered;
  }

  /// Union of all variables across the current category's formulas.
  List<String> get _categoryVariables {
    final set = <String>{};
    for (final f in _categoryFormulas) {
      set.addAll(f.variables);
    }
    final list = set.toList();
    // Prefer common single-letter variables first, then longer names.
    list.sort((a, b) {
      if (a.length != b.length) return a.length.compareTo(b.length);
      return a.compareTo(b);
    });
    return list;
  }

  /// Full physics pool used for chaining across categories.
  List<Formula> get _fullPhysicsPool => <Formula>[
    ...FormulaDatabase.physicsFormulas,
    ...HscPhysics1Database.hscPhysics1Formulas,
    ...HscPhysics2Database.hscPhysics2Formulas,
  ];

  /// Looks up the unit for a variable from the full pool.
  String? _unitFor(String variable) {
    for (final f in _categoryFormulas) {
      final u = f.units[variable];
      if (u != null) return u;
    }
    for (final f in _fullPhysicsPool) {
      final u = f.units[variable];
      if (u != null) return u;
    }
    return null;
  }

  void _setTarget(String? newTarget) {
    setState(() {
      _targetVariable = newTarget;
      if (newTarget != null) {
        _values.remove(newTarget);
      }
    });
  }

  void _onChipTap(String variable) {
    if (variable == _targetVariable) {
      // Tapping the target chip just opens the "solve for" dropdown feel.
      return;
    }
    setState(() {
      _editingVariable = variable;
    });
  }

  void _onKeyTap(String key) {
    if (_editingVariable == null) return;
    setState(() {
      final current = _values[_editingVariable!] ?? '';
      if (key == '.' && current.contains('.')) return;
      _values[_editingVariable!] = current + key;
    });
  }

  void _onBackspace() {
    if (_editingVariable == null) return;
    setState(() {
      final current = _values[_editingVariable!] ?? '';
      _values[_editingVariable!] = current.isEmpty
          ? ''
          : current.substring(0, current.length - 1);
    });
  }

  void _onClear() {
    if (_editingVariable == null) return;
    setState(() {
      _values[_editingVariable!] = '';
    });
  }

  void _onSave() {
    setState(() {
      _editingVariable = null;
    });
  }

  void _onDeleteKnown(String variable) {
    setState(() {
      _values.remove(variable);
    });
  }

  bool get _canCalculate {
    if (_targetVariable == null) return false;
    return _values.entries.any(
      (e) => e.key != _targetVariable && e.value.isNotEmpty,
    );
  }

  void _onCalculate() {
    final target = _targetVariable;
    if (target == null) return;

    final known = <String, double>{};
    for (final entry in _values.entries) {
      if (entry.key == target) continue;
      if (entry.value.isEmpty) continue;
      final parsed = double.tryParse(entry.value);
      if (parsed != null) known[entry.key] = parsed;
    }

    if (known.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one known value.')),
      );
      return;
    }

    final chain = SolverEngine().solveChained(
      targetVariable: target,
      knownValues: known,
      formulaPool: _fullPhysicsPool,
    );

    if (chain == null || chain.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not solve. Try adding more known values or a different target.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PhysicsSolutionPage(steps: chain)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allVars = _categoryVariables;
    final target = _targetVariable;

    // Variables with values entered (excluding target).
    final knownVars = allVars
        .where((v) => v != target && (_values[v] ?? '').isNotEmpty)
        .toList();

    // Variables without values (excluding target).
    final unknownVars = allVars
        .where((v) => v != target && (_values[v] ?? '').isEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _sectionLabel(theme, 'SOLVE FOR'),
                const SizedBox(height: 10),
                _buildTargetDropdown(theme, allVars),
                const SizedBox(height: 28),

                if (knownVars.isNotEmpty) ...[
                  _sectionLabel(theme, 'KNOWN VALUES'),
                  const SizedBox(height: 12),
                  ...knownVars.map((v) => _knownTile(theme, v)),
                  const SizedBox(height: 24),
                ],

                if (unknownVars.isNotEmpty) ...[
                  _sectionLabel(theme, 'TAP TO ENTER A VALUE'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: unknownVars
                        .map((v) => _emptyChip(theme, v))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                const SizedBox(height: 12),
                _buildCalculateButton(theme),
              ],
            ),
          ),
          if (_editingVariable != null)
            PhysicsKeypad(
              variableLabel: _niceLabel(_editingVariable!),
              currentValue: _values[_editingVariable!] ?? '',
              unit: _unitFor(_editingVariable!),
              onKeyTap: _onKeyTap,
              onBackspace: _onBackspace,
              onClear: _onClear,
              onSave: _onSave,
            ),
        ],
      ),
    );
  }

  Widget _sectionLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildTargetDropdown(ThemeData theme, List<String> allVars) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _targetVariable,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.primary,
          ),
          hint: Text(
            'Select what you want to find',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 15,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          items: allVars
              .map(
                (v) => DropdownMenuItem(value: v, child: Text(_niceLabel(v))),
              )
              .toList(),
          onChanged: _setTarget,
        ),
      ),
    );
  }

  Widget _emptyChip(ThemeData theme, String variable) {
    return InkWell(
      onTap: () => _onChipTap(variable),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          _niceLabel(variable),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _knownTile(ThemeData theme, String variable) {
    final unit = _unitFor(variable);
    final value = _values[variable] ?? '';
    final displayValue = unit != null ? '$value $unit' : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _onChipTap(variable),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    variable,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '${_niceLabel(variable)}  =  $displayValue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.cancel, color: theme.colorScheme.outline),
                  onPressed: () => _onDeleteKnown(variable),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculateButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _canCalculate ? _onCalculate : null,
        child: const Text(
          'Calculate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _niceLabel(String v) {
    const map = {
      'm': 'Mass',
      'F': 'Force',
      'a': 'Acceleration',
      'v': 'Velocity',
      'u': 'Initial Velocity',
      't': 'Time',
      's': 'Displacement',
      'p': 'Momentum',
      'W': 'Work',
      'P': 'Power',
      'KE': 'Kinetic Energy',
      'PE': 'Potential Energy',
      'g': 'Gravity',
      'h': 'Height',
      'J': 'Impulse',
      'd': 'Distance',
      'r': 'Radius',
      'm1': 'Mass 1',
      'm2': 'Mass 2',
      'V': 'Voltage',
      'I': 'Current',
      'R': 'Resistance',
      'f': 'Frequency',
      'lambda': 'Wavelength',
      'T': 'Period',
    };
    return map[v] ?? v;
  }
}
