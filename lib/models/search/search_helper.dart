import '../formula.dart';
import '../physics/formula_database.dart';
import '../math/geometry_formula_database.dart';
import '../chemistry/chemistry_formula_database.dart';
import '../tools/constant.dart';
import '../tools/constant_database.dart';

class SearchResult {
  final String name;
  final String category;
  SearchResult(this.name, this.category);
}

class SearchHelper {
  static List<SearchResult> searchEverything(String query) {
    if (query.trim().isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    List<SearchResult> results = [];

    for (var f in FormulaDatabase.physicsFormulas) {
      if (f.name.toLowerCase().contains(lowerQuery)) {
        results.add(SearchResult(f.name, 'Physics'));
      }
    }
    for (var f in GeometryFormulaDatabase.geometryFormulas) {
      if (f.name.toLowerCase().contains(lowerQuery)) {
        results.add(SearchResult(f.name, 'Math'));
      }
    }
    for (var f in ChemistryFormulaDatabase.chemistryFormulas) {
      if (f.name.toLowerCase().contains(lowerQuery)) {
        results.add(SearchResult(f.name, 'Chemistry'));
      }
    }
    for (var c in ConstantDatabase.constants) {
      if (c.name.toLowerCase().contains(lowerQuery) ||
          c.symbol.toLowerCase().contains(lowerQuery)) {
        results.add(SearchResult(
            '${c.name} (${c.symbol}) = ${c.value} ${c.unit}', 'Constant'));
      }
    }
    return results;
  }
}