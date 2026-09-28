import 'package:flutter/material.dart';

class MathKeypad extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback onBackspace;
  final VoidCallback onSave;

  const MathKeypad({
    super.key,
    required this.onKeyTap,
    required this.onBackspace,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['7', '8', '9', 'DEL'],
      ['4', '5', '6', '/'],
      ['1', '2', '3', '*'],
      ['0', '.', '-', '+'],
      ['(', ')', 'SAVE'],
    ];

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: keys.map((row) {
          return Row(
            children: row.map((key) {
              final isAction = key == 'DEL' || key == 'SAVE';
              final isOperator = ['/', '*', '-', '+', '(', ')'].contains(key);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAction
                            ? (key == 'SAVE' ? Colors.green : Colors.redAccent)
                            : (isOperator
                                  ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                  : Theme.of(context).colorScheme.surface),
                        foregroundColor: isAction || isOperator
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        if (key == 'DEL') {
                          onBackspace();
                        } else if (key == 'SAVE') {
                          onSave();
                        } else {
                          onKeyTap(key);
                        }
                      },
                      child: Text(
                        key,
                        style: TextStyle(
                          fontSize: key.length > 1 ? 14 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
