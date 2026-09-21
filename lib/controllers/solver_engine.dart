import 'package:math_expressions/math_expressions.dart';
import '../models/formula.dart';

class SolverEngine {
  List<String> solve(Formula formula, String targetVariable, Map<String, double> knownValues) {
    List<String> steps = [];
    
    // Check if the answer is already known
    if (knownValues.containsKey(targetVariable)) {
      steps.add("The variable $targetVariable is already known: ${knownValues[targetVariable]}");
      return steps;
    }

    String equationString = formula.equations[targetVariable]!;
    steps.add("Step 1: Identify the unknown variable: $targetVariable");
    steps.add("Step 2: Rearrange the formula: $equationString");

    // Substitute known values into the equation
    String substitutedEquation = equationString;
    knownValues.forEach((key, value) {
      substitutedEquation = substitutedEquation.replaceAll(key, value.toString());
    });

    steps.add("Step 3: Substitute known values: $substitutedEquation");

    // Evaluate the expression using the math_expressions package
    try {
      GrammarParser p = GrammarParser();
      Expression exp = p.parse(substitutedEquation);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      steps.add("Step 4: Calculate the result: $eval");
    } catch (e) {
      steps.add("Error calculating: $e");
    }

    return steps;
  }
}