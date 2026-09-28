import 'package:flutter/material.dart';

class MatrixCalculatorPage extends StatefulWidget {
  const MatrixCalculatorPage({super.key});
  @override
  State<MatrixCalculatorPage> createState() => _MatrixCalculatorPageState();
}

class _MatrixCalculatorPageState extends State<MatrixCalculatorPage> {
  int _size = 2;
  List<List<TextEditingController>> _aControllers = [];
  List<List<TextEditingController>> _bControllers = [];
  String _result = '';

  @override
  void initState() {
    super.initState();
    _rebuildControllers();
  }

  void _rebuildControllers() {
    _aControllers = List.generate(
      _size,
      (_) => List.generate(_size, (_) => TextEditingController()),
    );
    _bControllers = List.generate(
      _size,
      (_) => List.generate(_size, (_) => TextEditingController()),
    );
  }

  List<List<double>> _readMatrix(List<List<TextEditingController>> ctrls) {
    return ctrls
        .map((row) => row.map((c) => double.tryParse(c.text) ?? 0.0).toList())
        .toList();
  }

  void _add() {
    final a = _readMatrix(_aControllers);
    final b = _readMatrix(_bControllers);
    final r = List.generate(
      _size,
      (i) => List.generate(_size, (j) => a[i][j] + b[i][j]),
    );
    _printResult('A + B', r);
  }

  void _subtract() {
    final a = _readMatrix(_aControllers);
    final b = _readMatrix(_bControllers);
    final r = List.generate(
      _size,
      (i) => List.generate(_size, (j) => a[i][j] - b[i][j]),
    );
    _printResult('A - B', r);
  }

  void _multiply() {
    final a = _readMatrix(_aControllers);
    final b = _readMatrix(_bControllers);
    final r = List.generate(
      _size,
      (i) => List.generate(_size, (j) {
        double sum = 0;
        for (int k = 0; k < _size; k++) {
          sum += a[i][k] * b[k][j];
        }
        return sum;
      }),
    );
    _printResult('A × B', r);
  }

  double _determinant(List<List<double>> m) {
    if (m.length == 1) return m[0][0];
    if (m.length == 2) return m[0][0] * m[1][1] - m[0][1] * m[1][0];
    double det = 0;
    for (int i = 0; i < m.length; i++) {
      final sub = List.generate(
        m.length - 1,
        (r) => List.generate(m.length - 1, (c) => m[r + 1][c < i ? c : c + 1]),
      );
      det += (i % 2 == 0 ? 1 : -1) * m[0][i] * _determinant(sub);
    }
    return det;
  }

  void _detA() {
    final a = _readMatrix(_aControllers);
    final d = _determinant(a);
    setState(() => _result = 'det(A) = $d');
  }

  void _printResult(String name, List<List<double>> r) {
    setState(() {
      _result =
          '$name =\n${r.map((row) => row.map((v) => v.toStringAsFixed(2)).join('   ')).join('\n')}';
    });
  }

  Widget _buildMatrixInput(List<List<TextEditingController>> ctrls) {
    return Column(
      children: List.generate(
        _size,
        (i) => Row(
          children: List.generate(
            _size,
            (j) => Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: TextField(
                  controller: ctrls[i][j],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Matrix Size:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            value: _size,
            onChanged: (v) => setState(() {
              _size = v!;
              _rebuildControllers();
              _result = '';
            }),
            items: [2, 3]
                .map((s) => DropdownMenuItem(value: s, child: Text('$s×$s')))
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Matrix A:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildMatrixInput(_aControllers),
          const SizedBox(height: 16),
          const Text(
            'Matrix B:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildMatrixInput(_bControllers),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(onPressed: _add, child: const Text('A + B')),
              ElevatedButton(onPressed: _subtract, child: const Text('A - B')),
              ElevatedButton(onPressed: _multiply, child: const Text('A × B')),
              ElevatedButton(onPressed: _detA, child: const Text('det(A)')),
            ],
          ),
          const SizedBox(height: 20),
          if (_result.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
              ),
            ),
        ],
      ),
    );
  }
}
