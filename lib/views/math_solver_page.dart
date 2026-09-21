import 'package:flutter/material.dart';
import 'dart:math';
import '../models/formula.dart';
import '../models/math/geometry_formula_database.dart';
import '../controllers/solver_engine.dart';

class MathSolverPage extends StatefulWidget {
  const MathSolverPage({super.key});

  @override
  State<MathSolverPage> createState() => _MathSolverPageState();
}

class _MathSolverPageState extends State<MathSolverPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mathematics'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Algebra'),
              Tab(text: 'Geometry'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            QuadraticSolver(),
            GeometrySolver(),
          ],
        ),
      ),
    );
  }
}

// ============ QUADRATIC SOLVER ============
class QuadraticSolver extends StatefulWidget {
  const QuadraticSolver({super.key});
  @override
  State<QuadraticSolver> createState() => _QuadraticSolverState();
}

class _QuadraticSolverState extends State<QuadraticSolver> {
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  List<String> _steps = [];

  void _solveQuadratic() {
    double a = double.tryParse(_aController.text) ?? 0.0;
    double b = double.tryParse(_bController.text) ?? 0.0;
    double c = double.tryParse(_cController.text) ?? 0.0;

    List<String> newSteps = [];
    newSteps.add("Equation: $a x² + $b x + $c = 0");
    newSteps.add("Step 1: Identify coefficients: a = $a, b = $b, c = $c");

    if (a == 0) {
      newSteps.add("Error: 'a' cannot be zero in a quadratic equation.");
      setState(() { _steps = newSteps; });
      return;
    }

    double discriminant = (b * b) - (4 * a * c);
    newSteps.add("Step 2: Discriminant (Δ = b² - 4ac)");
    newSteps.add("Δ = ($b)² - 4($a)($c) = $discriminant");

    if (discriminant < 0) {
      newSteps.add("Since Δ < 0, there are no real roots.");
    } else if (discriminant == 0) {
      double x = -b / (2 * a);
      newSteps.add("Since Δ = 0, one real root: x = $x");
    } else {
      double x1 = (-b + sqrt(discriminant)) / (2 * a);
      double x2 = (-b - sqrt(discriminant)) / (2 * a);
      newSteps.add("Step 3: Apply x = (-b ± √Δ) / 2a");
      newSteps.add("x₁ = (-($b) + √$discriminant) / 2($a) = $x1");
      newSteps.add("x₂ = (-($b) - √$discriminant) / 2($a) = $x2");
    }
    setState(() { _steps = newSteps; });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ax² + bx + c = 0", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(controller: _aController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'a')),
          const SizedBox(height: 10),
          TextField(controller: _bController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'b')),
          const SizedBox(height: 10),
          TextField(controller: _cController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'c')),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _solveQuadratic, child: const Text('Solve Quadratic')),
          const SizedBox(height: 20),
          Expanded(child: ListView.builder(
            itemCount: _steps.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(_steps[index], style: const TextStyle(fontSize: 16)),
            ),
          )),
        ],
      ),
    );
  }
}

// ============ GEOMETRY SOLVER ============
class GeometrySolver extends StatefulWidget {
  const GeometrySolver({super.key});
  @override
  State<GeometrySolver> createState() => _GeometrySolverState();
}

class _GeometrySolverState extends State<GeometrySolver> {
  final _solver = SolverEngine();
  Formula _selectedFormula = GeometryFormulaDatabase.geometryFormulas[0];
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
            items: GeometryFormulaDatabase.geometryFormulas.map((f) => DropdownMenuItem(value: f, child: Text(f.name))).toList(),
          ),
          const SizedBox(height: 20),
          const Text("I want to solve for:"),
          DropdownButton<String>(
            value: _targetVariable,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() { _targetVariable = newValue; _steps = []; });
            },
            items: _selectedFormula.variables.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ..._selectedFormula.variables.where((v) => v != _targetVariable).map((variable) {
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