import '../formula.dart';

class FormulaDatabase {
  static final List<Formula> physicsFormulas = [
    // ============ KINEMATICS ============
    Formula(
      id: 'kin_1',
      name: 'Kinematics: v = u + at',
      variables: ['v', 'u', 'a', 't'],
      category: 'Kinematics',
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
      category: 'Kinematics',
      equations: {
        'v': 'sqrt(u^2 + 2*a*s)',
        'u': 'sqrt(v^2 - 2*a*s)',
        'a': '(v^2 - u^2)/(2*s)',
        's': '(v^2 - u^2)/(2*a)',
      },
    ),
    Formula(
      id: 'kin_3',
      name: 'Kinematics: s = ut + ½at²',
      variables: ['s', 'u', 'a', 't'],
      category: 'Kinematics',
      equations: {
        's': 'u*t + 0.5*a*t^2',
        'u': '(s - 0.5*a*t^2)/t',
        'a': '(2*(s - u*t))/(t^2)',
      },
    ),
    Formula(
      id: 'kin_4',
      name: 'Kinematics: s = ((u+v)/2)·t',
      variables: ['s', 'u', 'v', 't'],
      category: 'Kinematics',
      equations: {
        's': '((u + v)/2)*t',
        'u': '(2*s/t) - v',
        'v': '(2*s/t) - u',
        't': '(2*s)/(u + v)',
      },
    ),

    // ============ DYNAMICS ============
    Formula(
      id: 'force',
      name: 'Force: F = ma',
      variables: ['F', 'm', 'a'],
      category: 'Dynamics',
      equations: {'F': 'm*a', 'm': 'F/a', 'a': 'F/m'},
    ),
    Formula(
      id: 'momentum',
      name: 'Momentum: p = mv',
      variables: ['p', 'm', 'v'],
      category: 'Dynamics',
      equations: {'p': 'm*v', 'm': 'p/v', 'v': 'p/m'},
    ),
    Formula(
      id: 'work',
      name: 'Work: W = Fd',
      variables: ['W', 'F', 'd'],
      category: 'Energy',
      equations: {'W': 'F*d', 'F': 'W/d', 'd': 'W/F'},
    ),
    Formula(
      id: 'kinetic_energy',
      name: 'Kinetic Energy: KE = ½mv²',
      variables: ['KE', 'm', 'v'],
      category: 'Energy',
      equations: {
        'KE': '0.5*m*v^2',
        'm': '(2*KE)/(v^2)',
        'v': 'sqrt((2*KE)/m)',
      },
    ),
    Formula(
      id: 'potential_energy',
      name: 'Potential Energy: PE = mgh',
      variables: ['PE', 'm', 'g', 'h'],
      category: 'Energy',
      equations: {
        'PE': 'm*g*h',
        'm': 'PE/(g*h)',
        'g': 'PE/(m*h)',
        'h': 'PE/(m*g)',
      },
    ),
    Formula(
      id: 'power',
      name: 'Power: P = W/t',
      variables: ['P', 'W', 't'],
      category: 'Energy',
      equations: {'P': 'W/t', 'W': 'P*t', 't': 'W/P'},
    ),

    // ============ GRAVITATION ============
    Formula(
      id: 'gravity',
      name: 'Universal Gravitation: F = Gm₁m₂/r²',
      variables: ['F', 'm1', 'm2', 'r'],
      category: 'Gravitation',
      equations: {
        'F': '(6.674e-11*m1*m2)/(r^2)',
        'r': 'sqrt((6.674e-11*m1*m2)/F)',
      },
    ),

    // ============ WAVES ============
    Formula(
      id: 'wave',
      name: 'Wave: v = fλ',
      variables: ['v', 'f', 'lambda'],
      category: 'Waves',
      equations: {'v': 'f*lambda', 'f': 'v/lambda', 'lambda': 'v/f'},
    ),

    // ============ ELECTRICITY ============
    Formula(
      id: 'ohms_law',
      name: "Ohm's Law: V = IR",
      variables: ['V', 'I', 'R'],
      category: 'Electromagnetism',
      equations: {'V': 'I*R', 'I': 'V/R', 'R': 'V/I'},
    ),
    Formula(
      id: 'electric_power',
      name: 'Electric Power: P = VI',
      variables: ['P', 'V', 'I'],
      category: 'Electromagnetism',
      equations: {'P': 'V*I', 'V': 'P/I', 'I': 'P/V'},
    ),
  ];
}
