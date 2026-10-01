import 'package:flutter/material.dart';

import '../../models/formula.dart';
import '../../models/physics/formula_database.dart';
import '../../models/physics/hsc_physics1_database.dart';
import '../../models/physics/hsc_physics2_database.dart';
import 'physics_solver_page.dart';

class PhysicsHomePage extends StatelessWidget {
  const PhysicsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Combine all physics formulas
    final allFormulas = <Formula>[
      ...FormulaDatabase.physicsFormulas,
      ...HscPhysics1Database.hscPhysics1Formulas,
      ...HscPhysics2Database.hscPhysics2Formulas,
    ];

    // Build a category map with a stable order
    final categoryOrder = <String>[
      'Kinematics',
      'Dynamics',
      'Energy',
      'Gravitation',
      'Waves',
      'Thermodynamics',
      'Electromagnetism',
      'Optics',
      'Modern Physics',
      'Nuclear',
      'Fluids',
      'Astronomy',
    ];

    final catMap = <String, List<Formula>>{};
    for (final f in allFormulas) {
      catMap.putIfAbsent(f.category, () => []).add(f);
    }

    // Any categories not in the predefined order go at the end
    final extras = catMap.keys
        .where((k) => !categoryOrder.contains(k))
        .toList();

    final displayCats = [...categoryOrder.where(catMap.containsKey), ...extras];

    return Scaffold(
      appBar: AppBar(title: const Text('All topics'), elevation: 0),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: displayCats.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 76,
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
        itemBuilder: (context, i) {
          final name = displayCats[i];
          final formulas = catMap[name]!;
          return _categoryTile(context, name, formulas, allFormulas);
        },
      ),
    );
  }

  Widget _categoryTile(
    BuildContext context,
    String name,
    List<Formula> formulas,
    List<Formula> allFormulas,
  ) {
    final color = _colorFor(name);
    final initials = _initialsFor(name);
    final description = _descriptionFor(name, formulas.length);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                PhysicsSolverPage(categoryName: name, allFormulas: allFormulas),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.info_outline,
              size: 20,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(String name) {
    const map = {
      'Kinematics': Color(0xFF1976D2),
      'Dynamics': Color(0xFFD32F2F),
      'Energy': Color(0xFFF57C00),
      'Gravitation': Color(0xFF7B1FA2),
      'Waves': Color(0xFF00897B),
      'Thermodynamics': Color(0xFFD84315),
      'Electromagnetism': Color(0xFF3949AB),
      'Optics': Color(0xFFFFA000),
      'Modern Physics': Color(0xFF00ACC1),
      'Nuclear': Color(0xFF43A047),
      'Fluids': Color(0xFF0288D1),
      'Astronomy': Color(0xFFC2185B),
    };
    return map[name] ?? const Color(0xFF616161);
  }

  String _initialsFor(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  String _descriptionFor(String name, int count) {
    const desc = {
      'Kinematics': 'Velocity, Acceleration, Displacement, Time',
      'Dynamics': 'Force, Mass, Momentum, Impulse',
      'Energy': 'Work, Kinetic Energy, Potential Energy, Power',
      'Gravitation': 'Gravitational Force, Orbital Motion',
      'Waves': 'Frequency, Wavelength, Wave Speed',
      'Thermodynamics': 'Heat, Entropy, Ideal Gas Laws',
      'Electromagnetism': 'Voltage, Current, Resistance, Power',
      'Optics': 'Lenses, Mirrors, Refraction',
      'Modern Physics': 'Photons, Relativity, Bohr Model',
      'Nuclear': 'Radioactive Decay, Binding Energy',
      'Fluids': 'Pressure, Density, Viscosity',
      'Astronomy': 'Hubble Law, Stellar Motion',
    };
    return desc[name] ?? '$count formulas';
  }
}
