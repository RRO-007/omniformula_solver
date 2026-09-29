import '../models/formula.dart';
import '../models/physics/formula_database.dart';
import '../models/physics/hsc_physics1_database.dart';
import '../models/physics/hsc_physics2_database.dart';
import '../models/math/math_formula_database.dart';
import '../models/math/geometry_formula_database.dart';
import '../models/chemistry/chemistry_formula_database.dart';
import '../models/chemistry/hsc_chem1_database.dart';
import 'solver_engine.dart';

class SmartSearchResult {
  final Formula formula;
  final String targetVariable;
  final Map<String, double> knownValues;
  final List<String> steps;

  SmartSearchResult(
    this.formula,
    this.targetVariable,
    this.knownValues,
    this.steps,
  );
}

class SmartSearch {
  static final List<Formula> _allFormulas = [
    ...FormulaDatabase.physicsFormulas,
    ...HscPhysics1Database.hscPhysics1Formulas,
    ...HscPhysics2Database.hscPhysics2Formulas,
    ...MathFormulaDatabase.mathFormulas,
    ...GeometryFormulaDatabase.geometryFormulas,
    ...ChemistryFormulaDatabase.chemistryFormulas,
    ...HscChem1Database.hscChem1Formulas,
  ];

  // Simple NLP mapping of common words to variable symbols
  static final Map<String, String> _wordToSymbol = {
    'mass': 'm',
    'force': 'F',
    'acceleration': 'a',
    'velocity': 'v',
    'speed': 'v',
    'time': 't',
    'distance': 's',
    'displacement': 's',
    'momentum': 'p',
    'energy': 'E',
    'work': 'W',
    'power': 'P',
    'voltage': 'V',
    'current': 'I',
    'resistance': 'R',
    'charge': 'Q',
    'capacitance': 'C',
    'wavelength': 'lambda',
    'frequency': 'f',
    'height': 'h',
    'gravity': 'g',
    'radius': 'r',
    'density': 'rho',
    'pressure': 'P',
    'volume': 'V',
    'temperature': 'T',
    'weight': 'W',
  };

  static SmartSearchResult? process(String query) {
    final lowerQuery = query.toLowerCase();

    // 1. Find all numbers and their associated keywords
    final Map<String, double> knownValues = {};
    final wordRegex = RegExp(r'(\w+)\s*(?:is|=)\s*([\d\.\-eE]+)');
    final matches = wordRegex.allMatches(lowerQuery);

    for (final match in matches) {
      final word = match.group(1)!.toLowerCase();
      final valueStr = match.group(2)!;
      final value = double.tryParse(valueStr);

      if (value != null && _wordToSymbol.containsKey(word)) {
        knownValues[_wordToSymbol[word]!] = value;
      }
    }

    if (knownValues.isEmpty) {
      return null;
    }

    // 2. Find the target variable (the word after 'what is' or 'find')
    String? targetVariable;
    final targetRegex = RegExp(r'(?:what is|find|solve for|calculate)\s+(\w+)');
    final targetMatch = targetRegex.firstMatch(lowerQuery);
    if (targetMatch != null) {
      final word = targetMatch.group(1)!.toLowerCase();
      if (_wordToSymbol.containsKey(word)) {
        targetVariable = _wordToSymbol[word];
      }
    }

    // 3. Find a formula that contains all known values AND the target variable
    for (final formula in _allFormulas) {
      final formulaVars = formula.variables.toSet();

      // Check if the formula has all the known variables
      final hasAllKnown = knownValues.keys.every(
        (k) => formulaVars.contains(k),
      );
      if (!hasAllKnown) {
        continue;
      }

      // If we have a target variable, check if the formula has it
      if (targetVariable != null && !formulaVars.contains(targetVariable)) {
        continue;
      }

      // If no target variable was found, try to solve for the missing one
      String finalTarget = targetVariable ?? '';
      if (finalTarget.isEmpty) {
        final missing = formulaVars.difference(knownValues.keys.toSet());
        if (missing.isEmpty) {
          continue;
        }
        finalTarget = missing.first;
      }

      // Solve it!
      final solver = SolverEngine();
      final steps = solver.solve(formula, finalTarget, knownValues);

      return SmartSearchResult(formula, finalTarget, knownValues, steps);
    }

    return null;
  }
}
