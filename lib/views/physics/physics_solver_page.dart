import 'package:flutter/material.dart';

import '../../controllers/solver_engine.dart';
import '../../models/formula.dart';
import '../../widgets/math_keypad.dart';
import '../../widgets/math_renderer.dart';

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
  final _solver = SolverEngine();
  late List<Formula> _filteredFormulas;
  late Formula _selectedFormula;

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  TextEditingController? _activeController;

  String? _targetVariable;
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    _filteredFormulas = _filterByCategory(
      widget.allFormulas,
      widget.categoryName,
    );
    _selectedFormula = _filteredFormulas[0];
    _initializeControllers();
  }

  List<Formula> _filterByCategory(List<Formula> formulas, String category) {
    if (category == 'All Topics') return formulas;

    final cat = category.toLowerCase();
    final filtered = formulas.where((f) {
      final n = f.name.toLowerCase();
      if (cat == 'kinematics')
        return n.contains('kinematics') ||
            n.contains('velocity') ||
            n.contains('displacement') ||
            n.contains('acceleration');
      if (cat == 'dynamics')
        return n.contains('force') ||
            n.contains('momentum') ||
            n.contains('newton') ||
            n.contains('impulse') ||
            n.contains('torque');
      if (cat == 'energy')
        return n.contains('work') ||
            n.contains('energy') ||
            n.contains('power') ||
            n.contains('spring');
      if (cat == 'gravitation')
        return n.contains('gravit') ||
            n.contains('orbit') ||
            n.contains('escape') ||
            n.contains('kepler');
      if (cat == 'waves')
        return n.contains('wave') ||
            n.contains('frequency') ||
            n.contains('period') ||
            n.contains('sound') ||
            n.contains('doppler');
      if (cat == 'thermodynamics')
        return n.contains('thermo') ||
            n.contains('heat') ||
            n.contains('gas') ||
            n.contains('entropy') ||
            n.contains('carnot');
      if (cat == 'electromagnetism')
        return n.contains('electric') ||
            n.contains('magnet') ||
            n.contains('ohm') ||
            n.contains('circuit') ||
            n.contains('capacitor');
      if (cat == 'optics')
        return n.contains('lens') ||
            n.contains('optics') ||
            n.contains('snell') ||
            n.contains('prism') ||
            n.contains('mirror');
      if (cat == 'modern physics')
        return n.contains('photon') ||
            n.contains('relativity') ||
            n.contains('broglie') ||
            n.contains('bohr');
      if (cat == 'nuclear')
        return n.contains('nuclear') ||
            n.contains('radioactive') ||
            n.contains('decay') ||
            n.contains('binding');
      if (cat == 'fluids')
        return n.contains('fluid') ||
            n.contains('stokes') ||
            n.contains('viscosity') ||
            n.contains('pressure');
      if (cat == 'astronomy')
        return n.contains('hubble') ||
            n.contains('star') ||
            n.contains('solar') ||
            n.contains('black hole');
      return true;
    }).toList();

    return filtered.isEmpty ? formulas : filtered;
  }

  void _initializeControllers() {
    _controllers.clear();
    _focusNodes.clear();
    for (var variable in _selectedFormula.variables) {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          setState(() {
            _activeController = controller;
          });
        }
      });
      _controllers[variable] = controller;
      _focusNodes[variable] = focusNode;
    }
    _targetVariable = _selectedFormula.variables.first;
    _steps = [];
  }

  void _solve() {
    Map<String, double> knownValues = {};
    for (var variable in _selectedFormula.variables) {
      if (variable != _targetVariable) {
        double val = double.tryParse(_controllers[variable]!.text) ?? 0.0;
        knownValues[variable] = val;
      }
    }
    setState(() {
      _steps = _solver.solve(_selectedFormula, _targetVariable!, knownValues);
    });
  }

  void _onKeyTap(String value) {
    if (_activeController != null) {
      _activeController!.text += value;
    }
  }

  void _onBackspace() {
    if (_activeController != null && _activeController!.text.isNotEmpty) {
      _activeController!.text = _activeController!.text.substring(
        0,
        _activeController!.text.length - 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the LaTeX formula if available, otherwise use the plain text name
    final displayFormula = _selectedFormula.latex ?? _selectedFormula.name;

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formula Display Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: MathRenderer(
                          formula: displayFormula,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Formula Selector (if multiple)
                  DropdownButton<Formula>(
                    value: _selectedFormula,
                    isExpanded: true,
                    onChanged: (Formula? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedFormula = newValue;
                          _initializeControllers();
                        });
                      }
                    },
                    items: _filteredFormulas.map((formula) {
                      return DropdownMenuItem(
                        value: formula,
                        child: Text(
                          formula.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Target Variable Selector
                  const Text(
                    "Solve for:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _targetVariable,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _targetVariable = newValue;
                        _steps = [];
                      });
                    },
                    items: _selectedFormula.variables.map((variable) {
                      return DropdownMenuItem(
                        value: variable,
                        child: Text(variable),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Dynamic Input Fields
                  ..._selectedFormula.variables
                      .where((v) => v != _targetVariable)
                      .map((variable) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextField(
                            controller: _controllers[variable],
                            focusNode: _focusNodes[variable],
                            readOnly: true, // Prevents system keyboard
                            decoration: InputDecoration(
                              labelText: 'Enter value for $variable',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                            onTap: () {
                              setState(() {
                                _activeController = _controllers[variable];
                              });
                            },
                          ),
                        );
                      }),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context)
                            .colorScheme
                            .onPrimary,
                      ),
                      onPressed: _solve,
                      child: const Text(
                        'Calculate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Solution Steps Display Card
                  if (_steps.isNotEmpty) ...[
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Solution:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._steps.map(
                              (step) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  step,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Custom Keypad at the bottom
          MathKeypad(
            onKeyTap: _onKeyTap,
            onBackspace: _onBackspace,
            onSave: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
