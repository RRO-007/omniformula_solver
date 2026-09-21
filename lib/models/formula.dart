class Formula {
  final String id;
  final String name;
  final List<String> variables; // e.g., ['F', 'm', 'a']
  final Map<String, String> equations; // e.g., {'F': 'm * a', 'a': 'F / m'}

  Formula({
    required this.id,
    required this.name,
    required this.variables,
    required this.equations,
  });
}
