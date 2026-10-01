import 'package:flutter/material.dart';

import '../../controllers/solver_engine.dart';
import '../../models/formula.dart';
import '../../widgets/math_renderer.dart';
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
  late List<Formula> _filteredFormulas;
  late Formula _selectedFormula;

  final Map<String, String> _values = {};
  String? _editingVariable;

  @override
  void initState() {
    super.initState();
    _filteredFormulas = _filterByCategory(
      widget.allFormulas,
      widget.categoryName,
    );
    _selectedFormula = _filteredFormulas.isNotEmpty
        ? _filteredFormulas[0]
        : widget.allFormulas[0];
  }

  List<Formula> _filterByCategory(List<Formula> formulas, String category) {
    if (category == 'All Topics') return formulas;
    final filtered = formulas
        .where((f) => f.category.toLowerCase() == category.toLowerCase())
        .toList();
    return filtered.isEmpty ? formulas : filtered;
  }

  void _selectFormula(Formula f) {
    setState(() {
      _selectedFormula = f;
      _values.clear();
      _editingVariable = null;
    });
  }

  String? get _targetVariable {
    final unknowns = _selectedFormula.variables
        .where((v) => (_values[v] ?? '').isEmpty)
        .toList();
    return unknowns.length == 1 ? unknowns.first : null;
  }

  bool get _canCalculate => _targetVariable != null;

  void _onChipTap(String variable) {
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

  void _onCalculate() {
    final target = _targetVariable;
    if (target == null) return;

    final known = <String, double>{};
    for (final v in _selectedFormula.variables) {
      if (v != target) {
        final raw = _values[v];
        if (raw != null && raw.isNotEmpty) {
          final parsed = double.tryParse(raw);
          if (parsed != null) known[v] = parsed;
        }
      }
    }

    final result = SolverEngine().solveDetailed(
      _selectedFormula,
      target,
      known,
    );
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not solve. Check your values.')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PhysicsSolutionPage(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _buildFormulaCard(theme),
                const SizedBox(height: 20),
                _buildFormulaSelector(theme),
                const SizedBox(height: 24),
                _buildUnknownSection(theme),
                const SizedBox(height: 20),
                _buildKnownSection(theme),
                const SizedBox(height: 24),
                _buildCalculateButton(theme),
              ],
            ),
          ),
          if (_editingVariable != null)
            PhysicsKeypad(
              variableLabel: _niceLabel(_editingVariable!),
              currentValue: _values[_editingVariable!] ?? '',
              unit: _selectedFormula.units[_editingVariable!],
              onKeyTap: _onKeyTap,
              onBackspace: _onBackspace,
              onClear: _onClear,
              onSave: _onSave,
            ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: MathRenderer(formula: _selectedFormula.cleanLatex, fontSize: 28),
      ),
    );
  }

  Widget _buildFormulaSelector(ThemeData theme) {
    return DropdownButton<Formula>(
      value: _selectedFormula,
      isExpanded: true,
      underline: Container(height: 1, color: theme.colorScheme.outlineVariant),
      onChanged: (f) {
        if (f != null) _selectFormula(f);
      },
      items: _filteredFormulas
          .map(
            (f) => DropdownMenuItem(
              value: f,
              child: Text(
                f.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildUnknownSection(ThemeData theme) {
    final unknowns = _selectedFormula.variables
        .where((v) => (_values[v] ?? '').isEmpty)
        .toList();

    if (unknowns.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UNKNOWN VARIABLES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: unknowns.map((v) => _unknownChip(theme, v)).toList(),
        ),
      ],
    );
  }

  Widget _unknownChip(ThemeData theme, String variable) {
    final isTarget = _targetVariable == variable;
    final borderColor = isTarget
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    final textColor = isTarget
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: () => _onChipTap(variable),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          _niceLabel(variable),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildKnownSection(ThemeData theme) {
    final known = _selectedFormula.variables
        .where((v) => (_values[v] ?? '').isNotEmpty)
        .toList();

    if (known.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KNOWN VALUES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...known.map((v) => _knownTile(theme, v)),
      ],
    );
  }

  Widget _knownTile(ThemeData theme, String variable) {
    final unit = _selectedFormula.units[variable];
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
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
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
