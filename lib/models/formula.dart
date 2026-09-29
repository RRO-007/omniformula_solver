class Formula {
  final String id;
  final String name;
  final List<String> variables; // e.g., ['F', 'm', 'a']
  final Map<String, String>
  equations; // Plain text for math_expressions solving
  final String? latex; // LaTeX string for beautiful display
  final String category; // NEW: The category for the grid home screen

  Formula({
    required this.id,
    required this.name,
    required this.variables,
    required this.equations,
    this.latex, // Optional field
    this.category = 'General', // Default category
  });
}
