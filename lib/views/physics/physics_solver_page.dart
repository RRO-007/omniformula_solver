import 'package:flutter/material.dart';

import '../../controllers/solver_engine.dart';
import '../../models/formula.dart';
import '../../models/physics/formula_database.dart';
import '../../models/physics/hsc_physics1_database.dart';
import '../../models/physics/hsc_physics2_database.dart';

class PhysicsSolverPage extends StatelessWidget {
  const PhysicsSolverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Physics'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'HSC 1st Paper'),
              Tab(text: 'HSC 2nd Paper'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FormulaSolver(
              formulas: FormulaDatabase.physicsFormulas,
              hubName: 'General Physics',
            ),
            FormulaSolver(
              formulas: HscPhysics1Database.hscPhysics1Formulas,
              hubName: 'HSC Physics 1st Paper',
            ),
            FormulaSolver(
              formulas: HscPhysics2Database.hscPhysics2Formulas,
              hubName: 'HSC Physics 2nd Paper',
            ),
          ],
        ),
      ),
    );
  }
}

class FormulaSolver extends StatefulWidget {
  final List<Formula> formulas;
  final String hubName;

  const FormulaSolver({
    super.key,
    required this.formulas,
    required this.hubName,
  });

  @override
  State<FormulaSolver> createState() => _FormulaSolverState();
}

class _FormulaSolverState extends State<FormulaSolver> {
  final _solver = SolverEngine();
  late Formula _selectedFormula;

  final Map<String, TextEditingController> _controllers = {};
  String? _targetVariable;
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    _selectedFormula = widget.formulas[0];
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header showing which hub we're in
          Text(
            widget.hubName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Formula dropdown
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
            items: widget.formulas.map((formula) {
              return DropdownMenuItem(
                value: formula,
                child: Text(formula.name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

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
          const SizedBox(height: 12),

          // Dynamic input fields
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
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Enter value for $variable',
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _solve, child: const Text('Solve')),
                const SizedBox(height: 20),
                const Text(
                  'Workout Steps:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ..._steps.map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(step, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
