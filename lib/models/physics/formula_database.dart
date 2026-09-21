import '../formula.dart';

class FormulaDatabase {
  static final List<Formula> physicsFormulas = [
    Formula(
      id: 'fma',
      name: 'Force (F = ma)',
      variables: ['F', 'm', 'a'],
      equations: {
        'F': 'm * a',
        'm': 'F / a',
        'a': 'F / m',
      },
    ),
    Formula(
      id: 'kinematics_v',
      name: 'Velocity (v = u + at)',
      variables: ['v', 'u', 'a', 't'],
      equations: {
        'v': 'u + a * t',
        'u': 'v - a * t',
        'a': '(v - u) / t',
        't': '(v - u) / a',
      },
    ),
    Formula(
      id: 'momentum',
      name: 'Momentum (p = mv)',
      variables: ['p', 'm', 'v'],
      equations: {
        'p': 'm * v',
        'm': 'p / v',
        'v': 'p / m',
      },
    ),
  ];
}