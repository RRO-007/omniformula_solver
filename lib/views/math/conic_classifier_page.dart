import 'package:flutter/material.dart';

class ConicClassifierPage extends StatefulWidget {
  const ConicClassifierPage({super.key});
  @override
  State<ConicClassifierPage> createState() => _ConicClassifierPageState();
}

class _ConicClassifierPageState extends State<ConicClassifierPage> {
  final _a = TextEditingController();
  final _h = TextEditingController();
  final _b = TextEditingController();
  final _g = TextEditingController();
  final _f = TextEditingController();
  final _c = TextEditingController();
  String _result = '';

  void _classify() {
    final a = double.tryParse(_a.text) ?? 0;
    final h = double.tryParse(_h.text) ?? 0;
    final b = double.tryParse(_b.text) ?? 0;
    final g = double.tryParse(_g.text) ?? 0;
    final f = double.tryParse(_f.text) ?? 0;
    final c = double.tryParse(_c.text) ?? 0;

    double delta =
        a * b * c + 2 * f * g * h - a * f * f - b * g * g - c * h * h;
    double hSqMinusAb = h * h - a * b;

    String type;
    if (delta == 0) {
      type = 'Pair of Straight Lines (Δ = 0)';
    } else if (a == b && h == 0) {
      type = 'Circle (a = b, h = 0)';
    } else if (hSqMinusAb == 0) {
      type = 'Parabola (h² - ab = 0, e = 1)';
    } else if (hSqMinusAb < 0) {
      type = 'Ellipse (h² - ab < 0, 0 < e < 1)';
    } else {
      type = 'Hyperbola (h² - ab > 0, e > 1)';
    }

    setState(() {
      _result =
          'Equation: $a x² + 2($h)xy + $b y² + 2($g)x + 2($f)y + $c = 0\n\n'
          'Δ = $delta\nh² - ab = $hSqMinusAb\n\n'
          'Conic Type: $type';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conic Classifier: ax² + 2hxy + by² + 2gx + 2fy + c = 0',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _a,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'a'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _h,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'h'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _b,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'b'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _g,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'g'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _f,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'f'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _c,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'c'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _classify,
            child: const Text('Classify Conic'),
          ),
          const SizedBox(height: 16),
          if (_result.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_result, style: const TextStyle(fontSize: 15)),
            ),
        ],
      ),
    );
  }
}
