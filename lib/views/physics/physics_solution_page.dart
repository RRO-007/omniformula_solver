import 'package:flutter/material.dart';

import '../../controllers/solver_engine.dart';
import '../../widgets/math_renderer.dart';

class PhysicsSolutionPage extends StatelessWidget {
  final SolutionResult result;

  const PhysicsSolutionPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(result.formulaName), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                _step(
                  context,
                  title: 'Firstly, recall the formula:',
                  latex: result.formulaLatex,
                ),
                const SizedBox(height: 28),
                _step(
                  context,
                  title: 'Substitute known variables into the equation:',
                  latex: result.substitutedLatex,
                ),
                const SizedBox(height: 28),
                _step(
                  context,
                  title: 'Solve for ${result.targetVariableName}:',
                  latex: result.resultLatex,
                ),
              ],
            ),
          ),
          _resultBar(context),
        ],
      ),
    );
  }

  Widget _step(
    BuildContext context, {
    required String title,
    required String latex,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Center(child: MathRenderer(formula: latex, fontSize: 28)),
      ],
    );
  }

  Widget _resultBar(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      color: primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${result.targetVariableName.toUpperCase()} =',
            style: TextStyle(
              color: onPrimary.withValues(alpha: 0.75),
              fontSize: 14,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            result.displayValue,
            style: TextStyle(
              color: onPrimary,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
