import '../formula.dart';

class GeometryFormulaDatabase {
  static final List<Formula> geometryFormulas = [
    Formula(
      id: 'area_circle',
      name: 'Area of Circle: A = πr²',
      variables: ['A', 'r'],
      equations: {'A': '3.14159 * r^2', 'r': 'sqrt(A / 3.14159)'},
    ),
    Formula(
      id: 'area_rectangle',
      name: 'Area of Rectangle: A = lw',
      variables: ['A', 'l', 'w'],
      equations: {'A': 'l * w', 'l': 'A / w', 'w': 'A / l'},
    ),
    Formula(
      id: 'area_triangle',
      name: 'Area of Triangle: A = ½bh',
      variables: ['A', 'b', 'h'],
      equations: {'A': '0.5 * b * h', 'b': '(2 * A) / h', 'h': '(2 * A) / b'},
    ),
    Formula(
      id: 'volume_sphere',
      name: 'Volume of Sphere: V = ⁴⁄₃πr³',
      variables: ['V', 'r'],
      equations: {'V': '(4/3) * 3.14159 * r^3', 'r': '((3 * V) / (4 * 3.14159))^(1/3)'},
    ),
    Formula(
      id: 'volume_cylinder',
      name: 'Volume of Cylinder: V = πr²h',
      variables: ['V', 'r', 'h'],
      equations: {'V': '3.14159 * r^2 * h', 'r': 'sqrt(V / (3.14159 * h))', 'h': 'V / (3.14159 * r^2)'},
    ),
    Formula(
      id: 'pythagorean',
      name: 'Pythagorean: c = √(a² + b²)',
      variables: ['c', 'a', 'b'],
      equations: {'c': 'sqrt(a^2 + b^2)', 'a': 'sqrt(c^2 - b^2)', 'b': 'sqrt(c^2 - a^2)'},
    ),
  ];
}