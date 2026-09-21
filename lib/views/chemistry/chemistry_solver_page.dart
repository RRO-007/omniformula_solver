import 'package:flutter/material.dart';
import '../../controllers/solver_engine.dart';
import '../../models/formula.dart';
import '../../models/chemistry/chemistry_formula_database.dart';
import 'periodic_table_page.dart';

class ChemistryPage extends StatelessWidget {
  const ChemistryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chemistry'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Periodic Table'),
              Tab(text: 'Solvers'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PeriodicTablePage(),
            ChemistrySolver(),
          ],
        ),
      ),
    );
  }
}

class ChemistrySolver extends StatefulWidget {
  const ChemistrySolver({super.key});
  @override
  State<ChemistrySolver> createState() => _ChemistrySolverState();
}

class _ChemistrySolverState extends State<ChemistrySolver> {
  final _solver = SolverEngine();
  Formula _selectedFormula = ChemistryFormulaDatabase.chemistryFormulas[0];
  final Map<String, TextEditingController> _controllers = {};
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
    for (var variable in _selectedFormula.variables) {
      if (variable != _targetVariable) {
        knownValues[variable] = double.tryParse(_controllers[variable]!.text) ?? 0.0;
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
            items: ChemistryFormulaDatabase.chemistryFormulas
                .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                .toList(),
          ),
          const SizedBox(height: 20),
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
            items: _selectedFormula.variables
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
          ),
          const SizedBox(height: 20),
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
                      decoration: InputDecoration(labelText: 'Enter value for $variable'),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _solve, child: const Text('Solve')),
                const SizedBox(height: 20),
                const Text('Workout Steps:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ..._steps.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(s, style: const TextStyle(fontSize: 16)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}