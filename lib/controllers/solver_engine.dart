import 'package:math_expressions/math_expressions.dart';
import '../models/formula.dart';

class SolverEngine {
  List<String> solve(Formula formula, String targetVariable, Map<String, double> knownValues) {
    List<String> steps = [];
    
    if (knownValues.containsKey(targetVariable)) {
      steps.add("The variable $targetVariable is already known: ${knownValues[targetVariable]}");
      return steps;
    }

    String equationString = formula.equations[targetVariable]!;
    steps.add("Step 1: Identify the unknown variable: $targetVariable");
    steps.add("Step 2: Rearrange the formula: $equationString");

    // CRITICAL FIX: Sort variables longest-first, and use word boundaries
    // so 's' doesn't replace the 's' inside 'sqrt()'.
    String substitutedEquation = equationString;
    final sortedEntries = knownValues.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    for (var entry in sortedEntries) {
      final regex = RegExp('\\b${entry.key}\\b');
      substitutedEquation = substitutedEquation.replaceAll(regex, entry.value.toString());
    }

    steps.add("Step 3: Substitute known values: $substitutedEquation");

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