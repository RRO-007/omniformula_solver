class Formula {
  final String id;
  final String name;
  final List<String> variables; // e.g., ['F', 'm', 'a']
  final Map<String, String>
  equations; // Plain text for math_expressions solving
  final String? latex; // NEW: LaTeX string for beautiful display

  Formula({
    required this.id,
    required this.name,
    required this.variables,
    required this.equations,
    this.latex, // Optional field
  });
}
