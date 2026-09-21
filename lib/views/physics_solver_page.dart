import 'package:flutter/material.dart';

import '../controllers/solver_engine.dart';
import '../models/formula.dart';
import '../models/formula_database.dart';

class PhysicsSolverPage extends StatefulWidget {
  const PhysicsSolverPage({super.key});

  @override
  State<PhysicsSolverPage> createState() => _PhysicsSolverPageState();
}

class _PhysicsSolverPageState extends State<PhysicsSolverPage> {
  final _solver = SolverEngine();
  Formula _selectedFormula = FormulaDatabase.physicsFormulas[0];

  // A map to hold the text controllers for each variable
  final Map<String, TextEditingController> _controllers = {};

  // The variable the user wants to solve for
  String? _targetVariable;
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (var variable in _selectedFormula.variables) {
      _controllers[variable] = TextEditingController();
    }
    _targetVariable = _selectedFormula.variables.first;
    _steps = [];
  }

  void _solve() {
    Map<String, double> knownValues = {};

    // Read the numbers from the text boxes
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Physics Solver')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to choose the formula
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
              items: FormulaDatabase.physicsFormulas.map((formula) {
                return DropdownMenuItem(
                  value: formula,
                  child: Text(formula.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Dropdown to choose which variable to solve for
            const Text("I want to solve for:"),
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
                return DropdownMenuItem(value: variable, child: Text(variable));
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Dynamically generate input boxes for all variables EXCEPT the target
            Expanded(
              child: ListView(
                children: [
                  ..._selectedFormula.variables
                      .where((v) => v != _targetVariable)
                      .map((variable) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextField(
                            controller: _controllers[variable],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter value for $variable',
                            ),
                          ),
                        );
                      })
                      ,
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _solve, child: const Text('Solve')),
                  const SizedBox(height: 20),
                  const Text(
                    'Workout Steps:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._steps
                      .map(
                        (step) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            step,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                      ,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
