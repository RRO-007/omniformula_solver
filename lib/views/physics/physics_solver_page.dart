import 'package:flutter/material.dart';

import '../../controllers/solver_engine.dart';
import '../../models/formula.dart';
import '../../widgets/math_keypad.dart';

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
    // Simple filter logic based on category name (you can expand this)
    _filteredFormulas = widget.allFormulas.where((f) {
      // This is a basic filter. In a real app, you'd tag formulas with categories.
      return true; // For now, show all to ensure nothing is lost
    }).toList();

    // If empty, fallback to all
    if (_filteredFormulas.isEmpty) {
      _filteredFormulas = widget.allFormulas;
    }

    _selectedFormula = _filteredFormulas[0];
    _initializeControllers();
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formula Dropdown
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

                  // Target Variable Dropdown
                  const Text(
                    "Solve for:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  const SizedBox(height: 16),

                  // Dynamic Input Fields
                  ..._selectedFormula.variables
                      .where((v) => v != _targetVariable)
                      .map((variable) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextField(
                            controller: _controllers[variable],
                            focusNode: _focusNodes[variable],
                            readOnly: true, // Prevents system keyboard from popping up
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Enter value for $variable',
                              border: const OutlineInputBorder(),
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
                      onPressed: _solve,
                      child: const Text(
                        'Calculate',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Steps Display
                  if (_steps.isNotEmpty) ...[
                    const Text(
                      'Solution Steps:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._steps.map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(step, style: const TextStyle(fontSize: 16)),
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
