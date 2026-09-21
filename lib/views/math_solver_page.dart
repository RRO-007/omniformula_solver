import 'package:flutter/material.dart';
import 'dart:math';

class MathSolverPage extends StatefulWidget {
  const MathSolverPage({super.key});

  @override
  State<MathSolverPage> createState() => _MathSolverPageState();
}

class _MathSolverPageState extends State<MathSolverPage> {
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  List<String> _steps = [];

  void _solveQuadratic() {
    double a = double.tryParse(_aController.text) ?? 0.0;
    double b = double.tryParse(_bController.text) ?? 0.0;
    double c = double.tryParse(_cController.text) ?? 0.0;

    List<String> newSteps = [];
    newSteps.add("Equation: ${a}x² + ${b}x + ${c} = 0");
    newSteps.add("Step 1: Identify the coefficients: a = $a, b = $b, c = $c");

    if (a == 0) {
      newSteps.add("Error: 'a' cannot be zero in a quadratic equation.");
      setState(() { _steps = newSteps; });
      return;
    }

    // Calculate Discriminant
    double discriminant = (b * b) - (4 * a * c);
    newSteps.add("Step 2: Calculate the Discriminant (Δ = b² - 4ac)");
    newSteps.add("Δ = ($b)² - 4($a)($c)");
    newSteps.add("Δ = $discriminant");

    if (discriminant < 0) {
      newSteps.add("Since Δ < 0, there are no real roots (imaginary roots).");
    } else if (discriminant == 0) {
      double x = -b / (2 * a);
      newSteps.add("Since Δ = 0, there is one real root.");
      newSteps.add("Step 3: Apply the formula x = -b / 2a");
      newSteps.add("x = -($b) / 2($a)");
      newSteps.add("x = $x");
    } else {
      double x1 = (-b + sqrt(discriminant)) / (2 * a);
      double x2 = (-b - sqrt(discriminant)) / (2 * a);
      newSteps.add("Since Δ > 0, there are two real roots.");
      newSteps.add("Step 3: Apply the formula x = (-b ± √Δ) / 2a");
      newSteps.add("x₁ = (-($b) + √$discriminant) / 2($a) = $x1");
      newSteps.add("x₂ = (-($b) - √$discriminant) / 2($a) = $x2");
    }

    setState(() {
      _steps = newSteps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Math Solver: Quadratic')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter values for ax² + bx + c = 0", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _aController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'a (coefficient of x²)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'b (coefficient of x)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'c (constant)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _solveQuadratic,
              child: const Text('Solve Quadratic Equation'),
            ),
            const SizedBox(height: 20),
            const Text('Workout Steps:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(_steps[index], style: const TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}