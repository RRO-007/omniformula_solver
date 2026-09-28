import 'package:flutter/material.dart';
import 'dart:math';
import '../models/formula.dart';
import '../models/math/geometry_formula_database.dart';
import '../models/math/math_formula_database.dart';
import '../controllers/solver_engine.dart';
import 'math/matrix_calculator_page.dart';
import 'math/conic_classifier_page.dart';

class MathSolverPage extends StatelessWidget {
  const MathSolverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mathematics'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Algebra'),
              Tab(text: 'Geometry'),
              Tab(text: 'Formula Hub'),
              Tab(text: 'Matrix'),
              Tab(text: 'Conic'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            QuadraticSolver(),
            GeometrySolver(),
            MathFormulaSolver(),
            ConicClassifierPage(),
            MatrixCalculatorPage(),
          ],
        ),
      ),
    );
  }
}

// ============ QUADRATIC ============
class QuadraticSolver extends StatefulWidget {
  const QuadraticSolver({super.key});
  @override
  State<QuadraticSolver> createState() => _QuadraticSolverState();
}

class _QuadraticSolverState extends State<QuadraticSolver> {
  final _a = TextEditingController();
  final _b = TextEditingController();
  final _c = TextEditingController();
  List<String> _steps = [];

  void _solve() {
    double a = double.tryParse(_a.text) ?? 0;
    double b = double.tryParse(_b.text) ?? 0;
    double c = double.tryParse(_c.text) ?? 0;
    List<String> s = [];
    s.add("Equation: $a x² + $b x + $c = 0");
    s.add("Step 1: a=$a, b=$b, c=$c");
    if (a == 0) { s.add("Error: a cannot be 0."); setState(() => _steps = s); return; }
    double d = b * b - 4 * a * c;
    s.add("Step 2: Δ = ($b)² - 4($a)($c) = $d");
    if (d < 0) s.add("Δ < 0 → no real roots.");
    else if (d == 0) { s.add("Δ = 0 → x = ${-b / (2 * a)}"); }
    else {
      s.add("Step 3: x = (-b ± √Δ)/2a");
      s.add("x₁ = ${(-b + sqrt(d)) / (2 * a)}");
      s.add("x₂ = ${(-b - sqrt(d)) / (2 * a)}");
    }
    setState(() => _steps = s);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(controller: _a, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'a')),
      TextField(controller: _b, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'b')),
      TextField(controller: _c, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'c')),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: _solve, child: const Text('Solve Quadratic')),
      const SizedBox(height: 16),
      Expanded(child: ListView.builder(itemCount: _steps.length, itemBuilder: (c, i) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(_steps[i], style: const TextStyle(fontSize: 16))))),
    ]));
  }
}

// ============ GEOMETRY ============
class GeometrySolver extends StatefulWidget {
  const GeometrySolver({super.key});
  @override
  State<GeometrySolver> createState() => _GeometrySolverState();
}

class _GeometrySolverState extends State<GeometrySolver> {
  final _solver = SolverEngine();
  Formula _formula = GeometryFormulaDatabase.geometryFormulas[0];
  final Map<String, TextEditingController> _ctrls = {};
  String? _target;
  List<String> _steps = [];

  @override
  void initState() { super.initState(); _init(); }

  void _init() {
    _ctrls.clear();
    for (var v in _formula.variables) _ctrls[v] = TextEditingController();
    _target = _formula.variables.first;
    _steps = [];
  }

  void _solve() {
    Map<String, double> known = {};
    for (var v in _formula.variables) {
      if (v != _target) known[v] = double.tryParse(_ctrls[v]!.text) ?? 0;
    }
    setState(() => _steps = _solver.solve(_formula, _target!, known));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DropdownButton<Formula>(value: _formula, isExpanded: true, onChanged: (v) { setState(() { _formula = v!; _init(); }); },
        items: GeometryFormulaDatabase.geometryFormulas.map((f) => DropdownMenuItem(value: f, child: Text(f.name))).toList()),
      DropdownButton<String>(value: _target, isExpanded: true, onChanged: (v) => setState(() { _target = v; _steps = []; }),
        items: _formula.variables.map((v) => DropdownMenuItem(value: v, child: Text('Solve: $v'))).toList()),
      Expanded(child: ListView(children: [
        ..._formula.variables.where((v) => v != _target).map((v) => Padding(padding: const EdgeInsets.only(bottom: 8),
          child: TextField(controller: _ctrls[v], keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Enter $v')))),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: _solve, child: const Text('Solve')),
        const SizedBox(height: 12),
        ..._steps.map((s) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(s, style: const TextStyle(fontSize: 16)))),
      ])),
    ]));
  }
}

// ============ FORMULA HUB (new math formulas) ============
class MathFormulaSolver extends StatefulWidget {
  const MathFormulaSolver({super.key});
  @override
  State<MathFormulaSolver> createState() => _MathFormulaSolverState();
}

class _MathFormulaSolverState extends State<MathFormulaSolver> {
  final _solver = SolverEngine();
  Formula _formula = MathFormulaDatabase.mathFormulas[0];
  final Map<String, TextEditingController> _ctrls = {};
  String? _target;
  List<String> _steps = [];

  @override
  void initState() { super.initState(); _init(); }

  void _init() {
    _ctrls.clear();
    for (var v in _formula.variables) _ctrls[v] = TextEditingController();
    _target = _formula.variables.first;
    _steps = [];
  }

  void _solve() {
    Map<String, double> known = {};
    for (var v in _formula.variables) {
      if (v != _target) known[v] = double.tryParse(_ctrls[v]!.text) ?? 0;
    }
    setState(() => _steps = _solver.solve(_formula, _target!, known));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DropdownButton<Formula>(value: _formula, isExpanded: true, onChanged: (v) { setState(() { _formula = v!; _init(); }); },
        items: MathFormulaDatabase.mathFormulas.map((f) => DropdownMenuItem(value: f, child: Text(f.name))).toList()),
      DropdownButton<String>(value: _target, isExpanded: true, onChanged: (v) => setState(() { _target = v; _steps = []; }),
        items: _formula.variables.map((v) => DropdownMenuItem(value: v, child: Text('Solve: $v'))).toList()),
      Expanded(child: ListView(children: [
        ..._formula.variables.where((v) => v != _target).map((v) => Padding(padding: const EdgeInsets.only(bottom: 8),
          child: TextField(controller: _ctrls[v], keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Enter $v (angles in radians)')))),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: _solve, child: const Text('Solve')),
        const SizedBox(height: 12),
        ..._steps.map((s) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(s, style: const TextStyle(fontSize: 16)))),
      ])),
    ]));
  }
}