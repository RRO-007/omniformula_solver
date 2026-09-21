import '../formula.dart';

class ChemistryFormulaDatabase {
  static final List<Formula> chemistryFormulas = [
    // --- MOLARITY ---
    Formula(
      id: 'molarity',
      name: 'Molarity: M = n / V',
      variables: ['M', 'n', 'V'],
      equations: {
        'M': 'n / V',
        'n': 'M * V',
        'V': 'n / M',
      },
    ),
    // --- DILUTION ---
    Formula(
      id: 'dilution',
      name: 'Dilution: M₁V₁ = M₂V₂',
      variables: ['M1', 'V1', 'M2', 'V2'],
      equations: {
        'M1': '(M2 * V2) / V1',
        'V1': '(M2 * V2) / M1',
        'M2': '(M1 * V1) / V2',
        'V2': '(M1 * V1) / M2',
      },
    ),
    // --- IDEAL GAS LAW ---
    Formula(
      id: 'ideal_gas_law',
      name: 'Ideal Gas: PV = nRT',
      variables: ['P', 'V', 'n', 'T'],
      equations: {
        'P': '(n * 0.0821 * T) / V',
        'V': '(n * 0.0821 * T) / P',
        'n': '(P * V) / (0.0821 * T)',
        'T': '(P * V) / (n * 0.0821)',
      },
    ),
    // --- PERCENT YIELD ---
    Formula(
      id: 'percent_yield',
      name: 'Percent Yield = (Actual / Theoretical) × 100',
      variables: ['PY', 'Actual', 'Theoretical'],
      equations: {
        'PY': '(Actual / Theoretical) * 100',
        'Actual': '(PY * Theoretical) / 100',
        'Theoretical': '(Actual * 100) / PY',
      },
    ),
    // --- DENSITY ---
    Formula(
      id: 'density',
      name: 'Density: d = m / V',
      variables: ['d', 'm', 'V'],
      equations: {
        'd': 'm / V',
        'm': 'd * V',
        'V': 'm / d',
      },
    ),
    // --- MOLES ---
    Formula(
      id: 'moles',
      name: 'Moles: n = mass / molarMass',
      variables: ['n', 'mass', 'molarMass'],
      equations: {
        'n': 'mass / molarMass',
        'mass': 'n * molarMass',
        'molarMass': 'mass / n',
      },
    ),
  ];
}