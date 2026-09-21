import 'package:flutter/material.dart';
import '../../models/tools/constant.dart';
import '../../models/tools/constant_database.dart';

class ScientificToolsPage extends StatefulWidget {
  const ScientificToolsPage({super.key});

  @override
  State<ScientificToolsPage> createState() => _ScientificToolsPageState();
}

class _ScientificToolsPageState extends State<ScientificToolsPage> {
  final _inputController = TextEditingController();
  String _conversionType = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double _result = 0.0;
  String _formulaText = '';

  // Conversion factors to the base unit (Meters for Length, Grams for Mass)
  final Map<String, Map<String, double>> _conversionFactors = {
    'Length': {
      'Meters': 1.0,
      'Kilometers': 1000.0,
      'Centimeters': 0.01,
      'Miles': 1609.34,
      'Inches': 0.0254,
    },
    'Mass': {
      'Kilograms': 1000.0,
      'Grams': 1.0,
      'Pounds': 453.592,
      'Ounces': 28.3495,
    }
  };

  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0.0;
    if (input == 0.0) return;

    double fromFactor = _conversionFactors[_conversionType]![_fromUnit]!;
    double toFactor = _conversionFactors[_conversionType]![_toUnit]!;

    // Convert to base unit, then to target unit
    double baseValue = input * fromFactor;
    double finalValue = baseValue / toFactor;

    setState(() {
      _formulaText = '$input $_fromUnit = ${finalValue.toStringAsFixed(4)} $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scientific Tools'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Unit Converter'),
              Tab(text: 'Constants'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildConverterTab(context),
            _buildConstantsTab(context),
          ],
        ),
      ),
    );
  }

  // The original converter UI, just moved into its own method
  Widget _buildConverterTab(BuildContext context) {
    List<String> units = _conversionFactors[_conversionType]!.keys.toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: _conversionType,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _conversionType = newValue!;
                _fromUnit = _conversionFactors[_conversionType]!.keys.first;
                _toUnit = _conversionFactors[_conversionType]!.keys.last;
              });
            },
            items: _conversionFactors.keys.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _inputController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter value to convert'),
          ),
          const SizedBox(height: 20),
          const Text("From:"),
          DropdownButton<String>(
            value: _fromUnit,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() { _fromUnit = newValue!; });
            },
            items: units.map((unit) {
              return DropdownMenuItem(value: unit, child: Text(unit));
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text("To:"),
          DropdownButton<String>(
            value: _toUnit,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() { _toUnit = newValue!; });
            },
            items: units.map((unit) {
              return DropdownMenuItem(value: unit, child: Text(unit));
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _convert,
            child: const Text('Convert'),
          ),
          const SizedBox(height: 20),
          if (_formulaText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formulaText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // The new Constants library UI
  Widget _buildConstantsTab(BuildContext context) {
    return ListView.builder(
      itemCount: ConstantDatabase.constants.length,
      itemBuilder: (context, index) {
        final constant = ConstantDatabase.constants[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                constant.symbol,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(constant.name),
            subtitle: Text('${constant.value} ${constant.unit}'),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied ${constant.symbol} to clipboard!')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}