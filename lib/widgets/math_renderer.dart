import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathRenderer extends StatelessWidget {
  final String formula;
  final double fontSize;

  const MathRenderer({super.key, required this.formula, this.fontSize = 22});

  @override
  Widget build(BuildContext context) {
    if (formula.isEmpty) return const SizedBox.shrink();

    // A simple check to see if it's likely LaTeX
    final isLatex =
        formula.contains('\\') ||
        formula.contains('^') ||
        formula.contains('_') ||
        formula.contains('{');

    if (isLatex) {
      try {
        return Math.tex(
          formula,
          mathStyle: MathStyle.display,
          textStyle: TextStyle(fontSize: fontSize),
        );
      } catch (e) {
        // If LaTeX fails, silently fall back to plain text
      }
    }
    return Text(
      formula,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
    );
  }
}
