import 'package:flutter/material.dart';

import '../../models/physics/formula_database.dart';
import '../../models/physics/hsc_physics1_database.dart';
import '../../models/physics/hsc_physics2_database.dart';
import '../../models/formula.dart';
import 'physics_solver_page.dart';

class PhysicsHomePage extends StatelessWidget {
  const PhysicsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Combine all physics formulas
    final allFormulas = [
      ...FormulaDatabase.physicsFormulas,
      ...HscPhysics1Database.hscPhysics1Formulas,
      ...HscPhysics2Database.hscPhysics2Formulas,
    ];

    // Define our main categories based on the screenshots
    final categories = [
      {'name': 'Kinematics', 'icon': Icons.speed, 'color': Colors.blue},
      {'name': 'Dynamics', 'icon': Icons.fitness_center, 'color': Colors.red},
      {'name': 'Energy', 'icon': Icons.bolt, 'color': Colors.orange},
      {'name': 'Gravitation', 'icon': Icons.public, 'color': Colors.purple},
      {'name': 'Waves', 'icon': Icons.waves, 'color': Colors.teal},
      {
        'name': 'Thermodynamics',
        'icon': Icons.thermostat,
        'color': Colors.deepOrange,
      },
      {
        'name': 'Electromagnetism',
        'icon': Icons.electric_bolt,
        'color': Colors.indigo,
      },
      {'name': 'Optics', 'icon': Icons.light_mode, 'color': Colors.amber},
      {'name': 'Modern Physics', 'icon': Icons.science, 'color': Colors.cyan},
      {'name': 'Nuclear', 'icon': Icons.warning_amber, 'color': Colors.green},
      {'name': 'Fluids', 'icon': Icons.water, 'color': Colors.lightBlue},
      {'name': 'Astronomy', 'icon': Icons.star, 'color': Colors.pink},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Physics Topics'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return _buildCategoryCard(
              context,
              cat['name'] as String,
              cat['icon'] as IconData,
              cat['color'] as Color,
              allFormulas,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Formula> allFormulas,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to the solver page, passing the category name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhysicsSolverPage(
              categoryName: title,
              allFormulas: allFormulas,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          // Updated from withOpacity to withValues
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
