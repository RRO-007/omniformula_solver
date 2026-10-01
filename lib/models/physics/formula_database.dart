import '../formula.dart';

class FormulaDatabase {
  static final List<Formula> physicsFormulas = [
    // ============ KINEMATICS ============
    Formula(
      id: 'kin_1',
      name: 'Kinematics: v = u + at',
      variables: ['v', 'u', 'a', 't'],
      category: 'Kinematics',
      latex: 'v = u + a · t',
      equations: {
        'v': 'u + a * t',
        'u': 'v - a * t',
        'a': '(v - u) / t',
        't': '(v - u) / a',
      },
      units: {'v': 'm/s', 'u': 'm/s', 'a': 'm/s²', 't': 's'},
    ),
    Formula(
      id: 'kin_2',
      name: 'Kinematics: v² = u² + 2as',
      variables: ['v', 'u', 'a', 's'],
      category: 'Kinematics',
      latex: 'v^2 = u^2 + 2 · a · s',
      equations: {
        'v': 'sqrt(u^2 + 2*a*s)',
        'u': 'sqrt(v^2 - 2*a*s)',
        'a': '(v^2 - u^2)/(2*s)',
        's': '(v^2 - u^2)/(2*a)',
      },
      units: {'v': 'm/s', 'u': 'm/s', 'a': 'm/s²', 's': 'm'},
    ),
    Formula(
      id: 'kin_3',
      name: 'Kinematics: s = ut + ½at²',
      variables: ['s', 'u', 'a', 't'],
      category: 'Kinematics',
      latex: 's = u · t + \\frac{1}{2} · a · t^2',
      equations: {
        's': 'u*t + 0.5*a*t^2',
        'u': '(s - 0.5*a*t^2)/t',
        'a': '(2*(s - u*t))/(t^2)',
        't': '(-u + sqrt(u^2 + 2*a*s))/a',
      },
      units: {'s': 'm', 'u': 'm/s', 'a': 'm/s²', 't': 's'},
    ),
    Formula(
      id: 'kin_4',
      name: 'Kinematics: s = ((u+v)/2)·t',
      variables: ['s', 'u', 'v', 't'],
      category: 'Kinematics',
      latex: 's = \\frac{u + v}{2} · t',
      equations: {
        's': '((u + v)/2)*t',
        'u': '(2*s/t) - v',
        'v': '(2*s/t) - u',
        't': '(2*s)/(u + v)',
      },
      units: {'s': 'm', 'u': 'm/s', 'v': 'm/s', 't': 's'},
    ),

    // ============ DYNAMICS ============
    Formula(
      id: 'force',
      name: 'Force: F = ma',
      variables: ['F', 'm', 'a'],
      category: 'Dynamics',
      latex: 'F = m · a',
      equations: {'F': 'm*a', 'm': 'F/a', 'a': 'F/m'},
      units: {'F': 'N', 'm': 'kg', 'a': 'm/s²'},
    ),
    Formula(
      id: 'impulse_momentum',
      name: 'Impulse-Momentum: p = F·t',
      variables: ['p', 'F', 't'],
      category: 'Dynamics',
      latex: 'p = F · t',
      equations: {'p': 'F*t', 'F': 'p/t', 't': 'p/F'},
      units: {'p': 'kg·m/s', 'F': 'N', 't': 's'},
    ),
    Formula(
      id: 'momentum',
      name: 'Momentum: p = mv',
      variables: ['p', 'm', 'v'],
      category: 'Dynamics',
      latex: 'p = m · v',
      equations: {'p': 'm*v', 'm': 'p/v', 'v': 'p/m'},
      units: {'p': 'kg·m/s', 'm': 'kg', 'v': 'm/s'},
    ),
    Formula(
      id: 'weight',
      name: 'Weight: W = mg',
      variables: ['W', 'm', 'g'],
      category: 'Dynamics',
      latex: 'W = m · g',
      equations: {'W': 'm*g', 'm': 'W/g', 'g': 'W/m'},
      units: {'W': 'N', 'm': 'kg', 'g': 'm/s²'},
    ),

    // ============ ENERGY ============
    Formula(
      id: 'work',
      name: 'Work: W = F·d',
      variables: ['W', 'F', 'd'],
      category: 'Energy',
      latex: 'W = F · d',
      equations: {'W': 'F*d', 'F': 'W/d', 'd': 'W/F'},
      units: {'W': 'J', 'F': 'N', 'd': 'm'},
    ),
    Formula(
      id: 'kinetic_energy',
      name: 'Kinetic Energy: KE = ½mv²',
      variables: ['KE', 'm', 'v'],
      category: 'Energy',
      latex: 'E_k = \\frac{1}{2} m v^2',
      equations: {
        'KE': '0.5*m*v^2',
        'm': '(2*KE)/(v^2)',
        'v': 'sqrt((2*KE)/m)',
      },
      units: {'KE': 'J', 'm': 'kg', 'v': 'm/s'},
    ),
    Formula(
      id: 'potential_energy',
      name: 'Potential Energy: PE = mgh',
      variables: ['PE', 'm', 'g', 'h'],
      category: 'Energy',
      latex: 'E_p = m · g · h',
      equations: {
        'PE': 'm*g*h',
        'm': 'PE/(g*h)',
        'g': 'PE/(m*h)',
        'h': 'PE/(m*g)',
      },
      units: {'PE': 'J', 'm': 'kg', 'g': 'm/s²', 'h': 'm'},
    ),
    Formula(
      id: 'power',
      name: 'Power: P = W/t',
      variables: ['P', 'W', 't'],
      category: 'Energy',
      latex: 'P = \\frac{W}{t}',
      equations: {'P': 'W/t', 'W': 'P*t', 't': 'W/P'},
      units: {'P': 'W', 'W': 'J', 't': 's'},
    ),
    Formula(
      id: 'power_force_velocity',
      name: 'Power-Force: P = F·v',
      variables: ['P', 'F', 'v'],
      category: 'Energy',
      latex: 'P = F · v',
      equations: {'P': 'F*v', 'F': 'P/v', 'v': 'P/F'},
      units: {'P': 'W', 'F': 'N', 'v': 'm/s'},
    ),

    // ============ GRAVITATION ============
    Formula(
      id: 'gravity',
      name: 'Universal Gravitation: F = Gm₁m₂/r²',
      variables: ['F', 'm1', 'm2', 'r'],
      category: 'Gravitation',
      latex: 'F = \\frac{G · m_1 · m_2}{r^2}',
      equations: {
        'F': '(6.674e-11*m1*m2)/(r^2)',
        'r': 'sqrt((6.674e-11*m1*m2)/F)',
      },
      units: {'F': 'N', 'm1': 'kg', 'm2': 'kg', 'r': 'm'},
    ),

    // ============ WAVES ============
    Formula(
      id: 'wave',
      name: 'Wave: v = fλ',
      variables: ['v', 'f', 'lambda'],
      category: 'Waves',
      latex: 'v = f · \\lambda',
      equations: {'v': 'f*lambda', 'f': 'v/lambda', 'lambda': 'v/f'},
      units: {'v': 'm/s', 'f': 'Hz', 'lambda': 'm'},
    ),

    // ============ ELECTROMAGNETISM ============
    Formula(
      id: 'ohms_law',
      name: "Ohm's Law: V = IR",
      variables: ['V', 'I', 'R'],
      category: 'Electromagnetism',
      latex: 'V = I · R',
      equations: {'V': 'I*R', 'I': 'V/R', 'R': 'V/I'},
      units: {'V': 'V', 'I': 'A', 'R': 'Ω'},
    ),
    Formula(
      id: 'electric_power',
      name: 'Electric Power: P = VI',
      variables: ['P', 'V', 'I'],
      category: 'Electromagnetism',
      latex: 'P = V · I',
      equations: {'P': 'V*I', 'V': 'P/I', 'I': 'P/V'},
      units: {'P': 'W', 'V': 'V', 'I': 'A'},
    ),
  ];
}
