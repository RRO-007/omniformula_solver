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
  /// Legacy plain-text solver for chemistry / math.
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

  /// Structured single-formula solve.
  SolutionResult? solveDetailed(
    Formula formula,
    String targetVariable,
    Map<String, double> knownValues,
  ) {
    final equationString = formula.equations[targetVariable];
    if (equationString == null) return null;

    final numericExpr = _substitutePlain(equationString, knownValues);

    double result;
    try {
      final p = GrammarParser();
      final exp = p.parse(numericExpr);
      result = exp.evaluate(EvaluationType.REAL, ContextModel());
    } catch (_) {
      return null;
    }

    final formulaLatex = formula.cleanLatex;
    final substitutedLatex = _substituteLatex(formulaLatex, knownValues);

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

  /// Multi-step chained solve.
  List<SolutionResult>? solveChained({
    required String targetVariable,
    required Map<String, double> knownValues,
    required List<Formula> formulaPool,
    int maxDepth = 5,
  }) {
    return _chainRecursive(
      target: targetVariable,
      known: Map<String, double>.from(knownValues),
      pool: formulaPool,
      visiting: <String>{},
      depth: 0,
      maxDepth: maxDepth,
    );
  }

  List<SolutionResult>? _chainRecursive({
    required String target,
    required Map<String, double> known,
    required List<Formula> pool,
    required Set<String> visiting,
    required int depth,
    required int maxDepth,
  }) {
    if (known.containsKey(target)) return <SolutionResult>[];
    if (visiting.contains(target) || depth >= maxDepth) return null;

    final candidates = pool
        .where(
          (f) =>
              f.variables.contains(target) && f.equations.containsKey(target),
        )
        .toList();

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final aUnknown = a.variables
          .where((v) => v != target && !known.containsKey(v))
          .length;
      final bUnknown = b.variables
          .where((v) => v != target && !known.containsKey(v))
          .length;
      return aUnknown.compareTo(bUnknown);
    });

    visiting.add(target);

    for (final formula in candidates) {
      final needed = formula.variables.where((v) => v != target).toList();
      final localKnown = Map<String, double>.from(known);
      final chain = <SolutionResult>[];
      var failed = false;

      for (final v in needed) {
        if (localKnown.containsKey(v)) continue;

        final sub = _chainRecursive(
          target: v,
          known: localKnown,
          pool: pool,
          visiting: visiting,
          depth: depth + 1,
          maxDepth: maxDepth,
        );

        if (sub == null) {
          failed = true;
          break;
        }

        chain.addAll(sub);

        if (sub.isNotEmpty) {
          final last = sub.last;
          if (last.targetVariable == v) {
            localKnown[v] = last.value;
          }
        }

        if (!localKnown.containsKey(v)) {
          failed = true;
          break;
        }
      }

      if (failed) continue;

      final result = solveDetailed(formula, target, localKnown);
      if (result == null) continue;

      chain.add(result);
      visiting.remove(target);
      return chain;
    }

    visiting.remove(target);
    return null;
  }

  // ---------------------------------------------------------------------------
  // Bulletproof substitution — character scanner, no regex quirks.
  // ---------------------------------------------------------------------------

  static final RegExp _wordChar = RegExp(r'[A-Za-z_\\]');

  bool _isWordChar(String c) => _wordChar.hasMatch(c);

  String _substitutePlain(String source, Map<String, double> values) {
    return _scanAndReplace(source, values, evalMode: true);
  }

  String _substituteLatex(String source, Map<String, double> values) {
    return _scanAndReplace(source, values, evalMode: false);
  }

  String _scanAndReplace(
    String source,
    Map<String, double> values, {
    required bool evalMode,
  }) {
    if (values.isEmpty) return source;
    final keys = values.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    final buf = StringBuffer();
    int i = 0;
    while (i < source.length) {
      bool matched = false;
      for (final key in keys) {
        final end = i + key.length;
        if (end > source.length) continue;
        if (source.substring(i, end) != key) continue;

        final prevIsWord = i > 0 && _isWordChar(source[i - 1]);
        final nextIsWord = end < source.length && _isWordChar(source[end]);
        if (prevIsWord || nextIsWord) continue;

        buf.write('(${_fmt(values[key]!)})');
        i = end;
        matched = true;
        break;
      }
      if (!matched) {
        buf.write(source[i]);
        i++;
      }
    }
    return buf.toString();
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
