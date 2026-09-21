import '../formula.dart';

class FormulaDatabase {
  static final List<Formula> physicsFormulas = [
    // ============ KINEMATICS ============
    Formula(
      id: 'kin_1',
      name: 'Kinematics: v = u + at',
      variables: ['v', 'u', 'a', 't'],
      equations: {
        'v': 'u + a * t',
        'u': 'v - a * t',
        'a': '(v - u) / t',
        't': '(v - u) / a',
      },
    ),
    Formula(
      id: 'kin_2',
      name: 'Kinematics: v² = u² + 2as',
      variables: ['v', 'u', 'a', 's'],
      equations: {
        'v': 'sqrt(u^2 + 2 * a * s)',
        'u': 'sqrt(v^2 - 2 * a * s)',
        'a': '(v^2 - u^2) / (2 * s)',
        's': '(v^2 - u^2) / (2 * a)',
      },
    ),
    Formula(
      id: 'kin_3',
      name: 'Kinematics: s = ut + ½at²',
      variables: ['s', 'u', 'a', 't'],
      equations: {
        's': 'u * t + 0.5 * a * t^2',
        'u': '(s - 0.5 * a * t^2) / t',
        'a': '(2 * (s - u * t)) / (t^2)',
      },
    ),
    Formula(
      id: 'kin_4',
      name: 'Kinematics: s = ((u+v)/2)·t',
      variables: ['s', 'u', 'v', 't'],
      equations: {
        's': '((u + v) / 2) * t',
        'u': '(2 * s / t) - v',
        'v': '(2 * s / t) - u',
        't': '(2 * s) / (u + v)',
      },
    ),

    // ============ DYNAMICS ============
    Formula(
      id: 'force',
      name: 'Force: F = ma',
      variables: ['F', 'm', 'a'],
      equations: {'F': 'm * a', 'm': 'F / a', 'a': 'F / m'},
    ),
    Formula(
      id: 'momentum',
      name: 'Momentum: p = mv',
      variables: ['p', 'm', 'v'],
      equations: {'p': 'm * v', 'm': 'p / v', 'v': 'p / m'},
    ),
    Formula(
      id: 'work',
      name: 'Work: W = Fd',
      variables: ['W', 'F', 'd'],
      equations: {'W': 'F * d', 'F': 'W / d', 'd': 'W / F'},
    ),
    Formula(
      id: 'kinetic_energy',
      name: 'Kinetic Energy: KE = ½mv²',
      variables: ['KE', 'm', 'v'],
      equations: {
        'KE': '0.5 * m * v^2',
        'm': '(2 * KE) / (v^2)',
        'v': 'sqrt((2 * KE) / m)',
      },
    ),
    Formula(
      id: 'potential_energy',
      name: 'Potential Energy: PE = mgh',
      variables: ['PE', 'm', 'g', 'h'],
      equations: {
        'PE': 'm * g * h',
        'm': 'PE / (g * h)',
        'g': 'PE / (m * h)',
        'h': 'PE / (m * g)',
      },
    ),
    Formula(
      id: 'power',
      name: 'Power: P = W/t',
      variables: ['P', 'W', 't'],
      equations: {'P': 'W / t', 'W': 'P * t', 't': 'W / P'},
    ),

    // ============ CIRCULAR MOTION ============
    Formula(
      id: 'circ_vel',
      name: 'Circular: v = 2πr/T',
      variables: ['v', 'r', 'T'],
      equations: {
        'v': '(2 * 3.14159 * r) / T',
        'r': '(v * T) / (2 * 3.14159)',
        'T': '(2 * 3.14159 * r) / v',
      },
    ),
    Formula(
      id: 'centripetal_a',
      name: 'Centripetal Accel: a = v²/r',
      variables: ['a', 'v', 'r'],
      equations: {'a': '(v^2) / r', 'v': 'sqrt(a * r)', 'r': '(v^2) / a'},
    ),

    // ============ GRAVITATION ============
    Formula(
      id: 'gravity',
      name: 'Gravitation: F = Gm₁m₂/r²',
      variables: ['F', 'm1', 'm2', 'r'],
      equations: {
        'F': '(6.674e-11 * m1 * m2) / (r^2)',
        'r': 'sqrt((6.674e-11 * m1 * m2) / F)',
      },
    ),

    // ============ THERMODYNAMICS ============
    Formula(
      id: 'heat',
      name: 'Heat: Q = mcΔT',
      variables: ['Q', 'm', 'c', 'dT'],
      equations: {
        'Q': 'm * c * dT',
        'm': 'Q / (c * dT)',
        'c': 'Q / (m * dT)',
        'dT': 'Q / (m * c)',
      },
    ),
    Formula(
      id: 'ideal_gas',
      name: 'Ideal Gas: PV = nRT',
      variables: ['P', 'V', 'n', 'T'],
      equations: {
        'P': '(n * 8.314 * T) / V',
        'V': '(n * 8.314 * T) / P',
        'n': '(P * V) / (8.314 * T)',
        'T': '(P * V) / (n * 8.314)',
      },
    ),

    // ============ WAVES ============
    Formula(
      id: 'wave',
      name: 'Wave: v = fλ',
      variables: ['v', 'f', 'lambda'],
      equations: {
        'v': 'f * lambda',
        'f': 'v / lambda',
        'lambda': 'v / f',
      },
    ),
    Formula(
      id: 'period',
      name: 'Period: T = 1/f',
      variables: ['T', 'f'],
      equations: {'T': '1 / f', 'f': '1 / T'},
    ),

    // ============ ELECTRICITY ============
    Formula(
      id: 'ohms_law',
      name: "Ohm's Law: V = IR",
      variables: ['V', 'I', 'R'],
      equations: {'V': 'I * R', 'I': 'V / R', 'R': 'V / I'},
    ),
    Formula(
      id: 'electric_power',
      name: 'Electric Power: P = VI',
      variables: ['P', 'V', 'I'],
      equations: {'P': 'V * I', 'V': 'P / I', 'I': 'P / V'},
    ),
    Formula(
      id: 'charge',
      name: 'Charge: Q = It',
      variables: ['Q', 'I', 't'],
      equations: {'Q': 'I * t', 'I': 'Q / t', 't': 'Q / I'},
    ),

    // ============ QUANTUM / MODERN PHYSICS ============
    Formula(
      id: 'photon_energy',
      name: 'Photon Energy: E = hf',
      variables: ['E', 'f'],
      equations: {'E': '6.626e-34 * f', 'f': 'E / 6.626e-34'},
    ),
    Formula(
      id: 'mass_energy',
      name: 'Mass-Energy: E = mc²',
      variables: ['E', 'm'],
      equations: {'E': 'm * (3e8)^2', 'm': 'E / ((3e8)^2)'},
    ),
  ];
}