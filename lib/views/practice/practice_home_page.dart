import 'package:flutter/material.dart';

import 'practice_quiz_page.dart';

class PracticeHomePage extends StatelessWidget {
  const PracticeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Kinematics', 'icon': Icons.speed, 'color': Colors.blue},
      {'name': 'Energy', 'icon': Icons.bolt, 'color': Colors.orange},
      {'name': 'Forces', 'icon': Icons.fitness_center, 'color': Colors.red},
      {'name': 'Waves', 'icon': Icons.waves, 'color': Colors.teal},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Practice Mode'), elevation: 0),
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
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PracticeQuizPage(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: (cat['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (cat['color'] as Color).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 48,
                      color: cat['color'] as Color,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cat['name'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cat['color'] as Color,
                      ),
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
