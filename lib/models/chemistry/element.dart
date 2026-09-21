class ChemicalElement {
  final int atomicNumber;
  final String symbol;
  final String name;
  final double atomicMass;
  final String category;
  final String electronConfiguration;
  final double electronegativity;
  final String state;

  ChemicalElement({
    required this.atomicNumber,
    required this.symbol,
    required this.name,
    required this.atomicMass,
    required this.category,
    required this.electronConfiguration,
    required this.electronegativity,
    required this.state,
  });
}