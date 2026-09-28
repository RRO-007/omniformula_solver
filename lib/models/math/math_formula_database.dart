import '../formula.dart';

class MathFormulaDatabase {
  static final List<Formula> mathFormulas = [
    // --- COORDINATE GEOMETRY ---
    Formula(id: 'distance', name: 'Distance: d = √((x₂-x₁)² + (y₂-y₁)²)', variables: ['d', 'x1', 'y1', 'x2', 'y2'],
      equations: {'d': 'sqrt((x2-x1)^2 + (y2-y1)^2)'}),
    Formula(id: 'midpoint_x', name: 'Midpoint X: (x₁+x₂)/2', variables: ['mx', 'x1', 'x2'],
      equations: {'mx': '(x1+x2)/2'}),
    Formula(id: 'midpoint_y', name: 'Midpoint Y: (y₁+y₂)/2', variables: ['my', 'y1', 'y2'],
      equations: {'my': '(y1+y2)/2'}),
    Formula(id: 'slope', name: 'Slope: m = (y₂-y₁)/(x₂-x₁)', variables: ['m', 'y1', 'y2', 'x1', 'x2'],
      equations: {'m': '(y2-y1)/(x2-x1)'}),
    Formula(id: 'line_angle', name: 'Angle b/w Lines: tan(θ) = |(m₁-m₂)/(1+m₁m₂)|', variables: ['theta', 'm1', 'm2'],
      equations: {'theta': 'atan((m1-m2)/(1+m1*m2))'}),
    // --- ALGEBRA ---
    Formula(id: 'discriminant', name: 'Discriminant: Δ = b² - 4ac', variables: ['D', 'a', 'b', 'c'],
      equations: {'D': 'b^2 - 4*a*c'}),
    Formula(id: 'geometric_sum', name: 'Geometric Series: S = a(1-rⁿ)/(1-r)', variables: ['S', 'a', 'r', 'n'],
      equations: {'S': 'a*(1 - r^n)/(1 - r)'}),

    // --- LOGARITHMS ---
    Formula(id: 'log_product', name: 'Log Product: log(ab) = log(a) + log(b)', variables: ['L', 'a', 'b'],
      equations: {'L': 'log(a) + log(b)'}),
    Formula(id: 'log_quotient', name: 'Log Quotient: log(a/b) = log(a) - log(b)', variables: ['L', 'a', 'b'],
      equations: {'L': 'log(a) - log(b)'}),
    Formula(id: 'log_power', name: 'Log Power: log(aⁿ) = n·log(a)', variables: ['L', 'a', 'n'],
      equations: {'L': 'n*log(a)'}),

    // --- TRIGONOMETRY ---
    Formula(id: 'sin_rule', name: 'Sine Rule: a/sin(A) = b/sin(B)', variables: ['a', 'A', 'b', 'B'],
      equations: {'a': '(b*sin(A))/sin(B)', 'b': '(a*sin(B))/sin(A)'}),
    Formula(id: 'cos_rule', name: 'Cosine Rule: c² = a² + b² - 2ab·cos(C)', variables: ['c', 'a', 'b', 'C'],
      equations: {'c': 'sqrt(a^2 + b^2 - 2*a*b*cos(C))'}),

    // --- CALCULUS HELPERS ---
    Formula(id: 'power_rule_deriv', name: 'Power Rule: d/dx(xⁿ) = n·xⁿ⁻¹ (evaluate at x)', variables: ['result', 'n', 'x'],
      equations: {'result': 'n*x^(n-1)'}),
    Formula(id: 'power_rule_integral', name: 'Integral: ∫xⁿ dx = xⁿ⁺¹/(n+1)', variables: ['result', 'n', 'x'],
      equations: {'result': '(x^(n+1))/(n+1)'}),
  ];
}