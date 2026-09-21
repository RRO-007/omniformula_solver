import 'package:flutter/material.dart';
import '../../models/tools/constant.dart';
import '../../models/tools/constant_database.dart';
import '../../models/search/search_helper.dart';

class ScientificToolsPage extends StatefulWidget {
  const ScientificToolsPage({super.key});

  @override
  State<ScientificToolsPage> createState() => _ScientificToolsPageState();
}

class _ScientificToolsPageState extends State<ScientificToolsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scientific Tools'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Converter'),
              Tab(text: 'Constants'),
              Tab(text: 'Search'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UnitConverterTab(),
            ConstantsTab(),
            GlobalSearchTab(),
          ],
        ),
      ),
    );
  }
}

// ============ UNIT CONVERTER TAB ============
class UnitConverterTab extends StatefulWidget {
  const UnitConverterTab({super.key});
  @override
  State<UnitConverterTab> createState() => _UnitConverterTabState();
}

class _UnitConverterTabState extends State<UnitConverterTab> {
  final _inputController = TextEditingController();
  String _conversionType = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  String _resultText = '';

  final Map<String, Map<String, double>> _conversionFactors = {
    'Length': {
      'Meters': 1.0, 'Kilometers': 1000.0, 'Centimeters': 0.01,
      'Millimeters': 0.001, 'Miles': 1609.34, 'Yards': 0.9144,
      'Feet': 0.3048, 'Inches': 0.0254, 'Nautical Miles': 1852.0,
    },
    'Mass': {
      'Kilograms': 1000.0, 'Grams': 1.0, 'Milligrams': 0.001,
      'Pounds': 453.592, 'Ounces': 28.3495, 'Tons (metric)': 1000000.0,
    },
    'Time': {
      'Seconds': 1.0, 'Milliseconds': 0.001, 'Minutes': 60.0,
      'Hours': 3600.0, 'Days': 86400.0, 'Weeks': 604800.0, 'Years': 31536000.0,
    },
    'Volume': {
      'Liters': 1.0, 'Milliliters': 0.001, 'Cubic Meters': 1000.0,
      'Cubic Centimeters': 0.001, 'Gallons (US)': 3.78541,
      'Quarts (US)': 0.946353, 'Cups': 0.236588,
    },
    'Energy': {
      'Joules': 1.0, 'Kilojoules': 1000.0, 'Calories': 4.184,
      'Kilocalories': 4184.0, 'Electronvolts': 1.602176634e-19,
      'Kilowatt-hours': 3600000.0, 'BTU': 1055.06,
    },
    'Pressure': {
      'Pascals': 1.0, 'Kilopascals': 1000.0, 'Bars': 100000.0,
      'Atmospheres': 101325.0, 'PSI': 6894.76, 'mmHg': 133.322,
    },
    'Temperature': {'Celsius': 1.0, 'Fahrenheit': 1.0, 'Kelvin': 1.0},
  };

  @override
  void initState() {
    super.initState();
    _resetUnits();
  }

  void _resetUnits() {
    final units = _conversionFactors[_conversionType]!.keys.toList();
    _fromUnit = units.first;
    _toUnit = units.length > 1 ? units[1] : units.first;
    _resultText = '';
  }

  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0.0;
    double output;
    String formulaText;

    if (_conversionType == 'Temperature') {
      double celsius;
      switch (_fromUnit) {
        case 'Celsius': celsius = input; break;
        case 'Fahrenheit': celsius = (input - 32) * 5 / 9; break;
        case 'Kelvin': celsius = input - 273.15; break;
        default: celsius = input;
      }
      switch (_toUnit) {
        case 'Celsius': output = celsius; break;
        case 'Fahrenheit': output = (celsius * 9 / 5) + 32; break;
        case 'Kelvin': output = celsius + 273.15; break;
        default: output = celsius;
      }
      formulaText = 'Formula: Convert $input°$_fromUnit to $_toUnit';
    } else {
      double fromFactor = _conversionFactors[_conversionType]![_fromUnit]!;
      double toFactor = _conversionFactors[_conversionType]![_toUnit]!;
      output = (input * fromFactor) / toFactor;
      formulaText = 'Formula: ($input × $fromFactor) ÷ $toFactor';
    }

    setState(() {
      _resultText = '$input $_fromUnit = ${output.toStringAsFixed(6)} $_toUnit\n\n$formulaText';
    });
  }

  @override
  Widget build(BuildContext context) {
    final units = _conversionFactors[_conversionType]!.keys.toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _conversionType,
              isExpanded: true,
              onChanged: (v) {
                setState(() { _conversionType = v!; _resetUnits(); });
              },
              items: _conversionFactors.keys.map((t) =>
                  DropdownMenuItem(value: t, child: Text(t))).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(labelText: 'Enter value'),
            ),
            const SizedBox(height: 20),
            const Text("From:"),
            DropdownButton<String>(
              value: _fromUnit, isExpanded: true,
              onChanged: (v) => setState(() => _fromUnit = v!),
              items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            ),
            const SizedBox(height: 20),
            const Text("To:"),
            DropdownButton<String>(
              value: _toUnit, isExpanded: true,
              onChanged: (v) => setState(() => _toUnit = v!),
              items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _convert, child: const Text('Convert')),
            const SizedBox(height: 20),
            if (_resultText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_resultText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

// ============ CONSTANTS TAB (WITH SEARCH) ============
class ConstantsTab extends StatefulWidget {
  const ConstantsTab({super.key});
  @override
  State<ConstantsTab> createState() => _ConstantsTabState();
}

class _ConstantsTabState extends State<ConstantsTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = ConstantDatabase.constants.where((c) {
      return c.name.toLowerCase().contains(_query.toLowerCase()) ||
             c.symbol.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              labelText: 'Search constants...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final c = filtered[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(c.symbol, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(c.name),
                  subtitle: Text('${c.value} ${c.unit}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============ GLOBAL SEARCH TAB ============
class GlobalSearchTab extends StatefulWidget {
  const GlobalSearchTab({super.key});
  @override
  State<GlobalSearchTab> createState() => _GlobalSearchTabState();
}

class _GlobalSearchTabState extends State<GlobalSearchTab> {
  String _query = '';
  List<SearchResult> _results = [];

  void _performSearch(String query) {
    setState(() {
      _query = query;
      _results = SearchHelper.searchEverything(query);
    });
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Physics': return Colors.green;
      case 'Math': return Colors.blue;
      case 'Chemistry': return Colors.orange;
      case 'Constant': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: _performSearch,
            decoration: const InputDecoration(
              labelText: 'Search all formulas & constants...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: _query.isEmpty
              ? const Center(child: Text('Start typing to search...'))
              : _results.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final r = _results[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ListTile(
                            leading: Chip(
                              label: Text(r.category, style: const TextStyle(color: Colors.white, fontSize: 12)),
                              backgroundColor: _categoryColor(r.category),
                            ),
                            title: Text(r.name),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}