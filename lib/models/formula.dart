class Formula {
  final String id;
  final String name;
  final List<String> variables;
  final Map<String, String> equations;
  final String? latex;
  final String category;
  final Map<String, String> units;

  Formula({
    required this.id,
    required this.name,
    required this.variables,
    required this.equations,
    this.latex,
    this.category = 'General',
    this.units = const {},
  });

  /// Returns a clean LaTeX string for display.
  /// If [latex] is set, uses it. Otherwise, extracts the part after ":" in the name.
  /// Example: "Kinematics: v = u + at" → "v = u + at"
  String get cleanLatex {
    if (latex != null && latex!.isNotEmpty) return latex!;
    final parts = name.split(':');
    if (parts.length > 1) return parts.last.trim();
    return name;
  }
}
