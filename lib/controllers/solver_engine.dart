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
  /// Legacy solver returning plain-text steps (still used by chemistry/math).
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

    final substituted = _substitutePlain(equationString, knownValues);
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

  /// Structured solver for the physics page's beautiful step-by-step UI.
  SolutionResult? solveDetailed(
    Formula formula,
    String targetVariable,
    Map<String, double> knownValues,
  ) {
    final equationString = formula.equations[targetVariable];
    if (equationString == null) return null;

    // 1. Build a numeric expression with explicit parentheses for evaluation.
    final numericExpr = _substitutePlain(equationString, knownValues);

    // 2. Evaluate it.
    double result;
    try {
      final p = GrammarParser();
      final exp = p.parse(numericExpr);
      result = exp.evaluate(EvaluationType.REAL, ContextModel());
    } catch (_) {
      return null;
    }

    // 3. Build the two display strings (LaTeX).
    final formulaLatex = formula.cleanLatex;
    final substitutedLatex = _substituteLatex(formulaLatex, knownValues);

    // 4. Format the result.
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

  /// Plain-text substitution for `math_expressions` evaluation.
  String _substitutePlain(String source, Map<String, double> values) {
    if (values.isEmpty) return source;
    final keys = values.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    final pattern = RegExp(
      r'(?<![A-Za-z_])(' +
          keys.map(RegExp.escape).join('|') +
          r')(?![A-Za-z_])',
    );
    return source.splitMapJoin(
      pattern,
      onMatch: (m) {
        final key = m[0]!;
        final v = values[key]!;
        return '(${_fmt(v)})';
      },
      onNonMatch: (s) => s,
    );
  }

  /// LaTeX-safe substitution. Handles commands like `\cdot`, `\times`, `\sqrt{}`
  /// and only replaces variable names that are standalone tokens.
  String _substituteLatex(String source, Map<String, double> values) {
    if (values.isEmpty) return source;
    final keys = values.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    // A variable is only replaced when:
    //   - the char before is not a backslash, letter, or underscore
    //   - the char after is not a letter or underscore
    // This prevents accidental matches inside LaTeX commands like `\cdot`.
    final pattern = RegExp(
      r'(?<![\\A-Za-z_])(' +
          keys.map(RegExp.escape).join('|') +
          r')(?![A-Za-z_])',
    );

    return source.splitMapJoin(
      pattern,
      onMatch: (m) {
        final key = m[0]!;
        final v = values[key]!;
        return '(${_fmt(v)})';
      },
      onNonMatch: (s) => s,
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
      'r': 'radius',
      'm1': 'mass 1',
      'm2': 'mass 2',
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
