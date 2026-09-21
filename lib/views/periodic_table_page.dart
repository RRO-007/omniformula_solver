import 'package:flutter/material.dart';
import '../models/element.dart';
import '../models/element_database.dart';

class PeriodicTablePage extends StatelessWidget {
  const PeriodicTablePage({super.key});

  // A helper function to give each category a unique color
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Nonmetal': return Colors.green;
      case 'Noble Gas': return Colors.purple;
      case 'Alkali Metal': return Colors.red;
      case 'Alkaline Earth': return Colors.orange;
      case 'Metalloid': return Colors.teal;
      case 'Halogen': return Colors.blue;
      case 'Post-transition Metal': return Colors.brown;
      default: return Colors.grey;
    }
  }

  // This function builds the popup when an element is clicked
  void _showElementDetails(BuildContext context, ChemicalElement element) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${element.name} (${element.symbol})'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Atomic Number: ${element.atomicNumber}'),
                Text('Atomic Mass: ${element.atomicMass} u'),
                Text('Category: ${element.category}'),
                Text('State at Room Temp: ${element.state}'),
                Text('Electron Configuration: ${element.electronConfiguration}'),
                Text('Electronegativity: ${element.electronegativity}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate how many columns we can fit based on screen width
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 1200 ? 10 : width > 800 ? 8 : 5;

    return Scaffold(
      appBar: AppBar(title: const Text('Periodic Table')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          itemCount: ElementDatabase.elements.length,
          itemBuilder: (context, index) {
            final element = ElementDatabase.elements[index];
            return GestureDetector(
              onTap: () => _showElementDetails(context, element),
              child: Container(
                decoration: BoxDecoration(
                  color: _getCategoryColor(element.category).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${element.atomicNumber}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      element.symbol,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      element.name,
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}