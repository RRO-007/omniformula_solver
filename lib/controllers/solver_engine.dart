import 'package:math_expressions/math_expressions.dart';

import '../models/formula.dart';

class SolutionResult {
  final String formulaName;
  final String formulaLatex;
  final String substitutedLatex;
  final String resultLatex;
  final double value;
  final String targetVariable;
  final String targetVariableName;
  final String? unit;

  SolutionResult({
    required this.formulaName,
    required this.formulaLatex,
    required this.substitutedLatex,
    required this.resultLatex,
    required this.value,
    required this.targetVariable,
    required this.targetVariableName,
    this.unit,
  });

  String get displayValue {
    final rounded = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
    return unit != null ? '$rounded $unit' : rounded;
  }
}

class SolverEngine {
  /// Legacy solver that returns plain-text step strings.
  List<String> solve(
    Formula formula,
    String targetVariable,
    Map<String, double> knownValues,
  ) {
    final steps = <String>[];

    if (knownValues.containsKey(targetVariable)) {
      steps.add(
        "The variable $targetVariable is already known: "
        "${knownValues[targetVariable]}",
      );
      return steps;
    }

    final equationString = formula.equations[targetVariable];
    if (equationString == null) {
      steps.add("No equation found for $targetVariable.");
      return steps;
    }

    steps.add("Step 1: Identify the unknown variable: $targetVariable");
    steps.add("Step 2: Rearrange the formula: $equationString");

    String substituted = equationString;
    final sorted = knownValues.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in sorted) {
      final regex = RegExp('\\b${RegExp.escape(entry.key)}\\b');
      substituted = substituted.replaceAll(regex, entry.value.toString());
    }
    steps.add("Step 3: Substitute known values: $substituted");

    try {
      final p = GrammarParser();
      final exp = p.parse(substituted);
      final result = exp.evaluate(EvaluationType.REAL, ContextModel());
      steps.add("Step 4: Calculate the result: $result");
    } catch (e) {
      steps.add("Error calculating: $e");
    }
    return steps;
  }

  /// Detailed solver returning a structured result for beautiful step-by-step UI.
  SolutionResult? solveDetailed(
    Formula formula,
    String targetVariable,
    Map<String, double> knownValues,
  ) {
    final equationString = formula.equations[targetVariable];
    if (equationString == null) return null;

    // Build the evaluated expression with explicit parentheses.
    String substitutedExpr = equationString;
    final sorted = knownValues.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));
    for (final entry in sorted) {
      final regex = RegExp('\\b${RegExp.escape(entry.key)}\\b');
      substitutedExpr = substitutedExpr.replaceAll(regex, '(${entry.value})');
    }

    double result;
    try {
      final p = GrammarParser();
      final exp = p.parse(substitutedExpr);
      result = exp.evaluate(EvaluationType.REAL, ContextModel());
    } catch (e) {
      return null;
    }

    // Build LaTeX strings for the step-by-step view.
    final formulaLatex = formula.cleanLatex;

    // Substituted: replace each known variable with "(value)" in the formula latex.
    String substitutedLatex = formulaLatex;
    for (final entry in sorted) {
      final regex = RegExp('\\b${RegExp.escape(entry.key)}\\b');
      substitutedLatex = substitutedLatex.replaceAll(
        regex,
        '(${_fmt(entry.value)})',
      );
    }

    final rounded = result == result.roundToDouble()
        ? result.toInt().toString()
        : result.toStringAsFixed(2);
    final resultLatex = '$targetVariable = $rounded';

    return SolutionResult(
      formulaName: formula.name,
      formulaLatex: formulaLatex,
      substitutedLatex: substitutedLatex,
      resultLatex: resultLatex,
      value: result,
      targetVariable: targetVariable,
      targetVariableName: _niceName(targetVariable),
      unit: formula.units[targetVariable],
    );
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  String _niceName(String v) {
    const map = {
      'm': 'mass',
      'F': 'force',
      'a': 'acceleration',
      'v': 'velocity',
      'u': 'initial velocity',
      't': 'time',
      's': 'displacement',
      'p': 'momentum',
      'W': 'work',
      'P': 'power',
      'KE': 'kinetic energy',
      'PE': 'potential energy',
      'g': 'gravity',
      'h': 'height',
      'J': 'impulse',
      'd': 'distance',
      'V': 'voltage',
      'I': 'current',
      'R': 'resistance',
      'f': 'frequency',
      'lambda': 'wavelength',
      'T': 'period',
    };
    return map[v] ?? v;
  }
}
