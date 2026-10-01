import 'package:flutter/material.dart';

import '../../controllers/solver_engine.dart';
import '../../widgets/math_renderer.dart';

class PhysicsSolutionPage extends StatelessWidget {
  final List<SolutionResult> steps;

  const PhysicsSolutionPage({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final finalStep = steps.last;

    return Scaffold(
      appBar: AppBar(
        title: Text(finalStep.formulaName, overflow: TextOverflow.ellipsis),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                for (int i = 0; i < steps.length; i++) ...[
                  _buildSection(context, i, steps[i]),
                  if (i < steps.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Divider(
                        color: Theme.of(context).dividerColor
                            .withValues(alpha: 0.4),
                      ),
                    ),
                ],
              ],
            ),
          ),
          _resultBar(context, finalStep),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, int index, SolutionResult step) {
    final ordinal = _ordinal(index);
    final isFirst = index == 0;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step header
        Text(
          isFirst
              ? '$ordinal, recall the formula:'
              : '$ordinal, recall the ${_shortLabel(step.formulaName)}:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Center(child: MathRenderer(formula: step.formulaLatex, fontSize: 26)),
        const SizedBox(height: 26),

        // Substitute step
        Text(
          'Substitute known variables into the equation.',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: MathRenderer(formula: step.substitutedLatex, fontSize: 26),
        ),
        const SizedBox(height: 26),

        // Solve step
        Text(
          'Solve for ${step.targetVariableName}.',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Center(child: MathRenderer(formula: step.resultLatex, fontSize: 26)),
      ],
    );
  }

  Widget _resultBar(BuildContext context, SolutionResult step) {
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
            '${step.targetVariableName.toUpperCase()} =',
            style: TextStyle(
              color: onPrimary.withValues(alpha: 0.75),
              fontSize: 13,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            step.displayValue,
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

  String _ordinal(int index) {
    const names = [
      'Firstly',
      'Secondly',
      'Thirdly',
      'Fourthly',
      'Fifthly',
      'Sixthly',
    ];
    if (index < names.length) return names[index];
    return 'Step ${index + 1}';
  }

  /// Extracts a human-readable label from a formula name.
  /// "Kinematics: v = u + at" → "Kinematics Formula"
  /// "Force: F = ma"          → "Force Formula"
  String _shortLabel(String name) {
    final parts = name.split(':');
    if (parts.length > 1) {
      return '${parts.first.trim()} Formula';
    }
    return 'Formula';
  }
}
