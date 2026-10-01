import 'package:flutter/material.dart';

class PhysicsKeypad extends StatelessWidget {
  final String variableLabel;
  final String currentValue;
  final String? unit;
  final ValueChanged<String> onKeyTap;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onSave;

  const PhysicsKeypad({
    super.key,
    required this.variableLabel,
    required this.currentValue,
    this.unit,
    required this.onKeyTap,
    required this.onBackspace,
    required this.onClear,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = currentValue.isEmpty
        ? '0'
        : (unit != null ? '$currentValue $unit' : currentValue);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with variable name and current value
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1565C0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$variableLabel =',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayValue,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: onClear,
                  ),
                ],
              ),
            ),

            // Number pad
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _row(['7', '8', '9', 'DEL']),
                  _row(['4', '5', '6', '/']),
                  _row(['1', '2', '3', '*']),
                  _row(['.', '0', '-', '+']),
                  _saveRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(List<String> keys) {
    return Row(children: keys.map((k) => Expanded(child: _button(k))).toList());
  }

  Widget _saveRow() {
    return Row(
      children: [Expanded(flex: 3, child: _button('SAVE', isSave: true))],
    );
  }

  Widget _button(String key, {bool isSave = false}) {
    final isDel = key == 'DEL';
    final isOp = ['/', '*', '-', '+'].contains(key);

    Color bg;
    Color fg = Colors.white;

    if (isSave) {
      bg = const Color(0xFF2E7D32);
    } else if (isDel) {
      bg = const Color(0xFFC62828);
    } else if (isOp) {
      bg = const Color(0xFF37474F);
    } else {
      bg = const Color(0xFF2A2A2A);
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: 58,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (isDel) {
                onBackspace();
              } else if (key == 'SAVE') {
                onSave();
              } else {
                onKeyTap(key);
              }
            },
            child: Center(
              child: Text(
                key,
                style: TextStyle(
                  color: fg,
                  fontSize: key.length > 1 ? 15 : 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
