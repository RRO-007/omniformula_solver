import 'package:flutter/material.dart';

import '../controllers/update_service.dart';
import 'math_solver_page.dart';
import 'physics/physics_home_page.dart';
import 'chemistry/chemistry_solver_page.dart';
import 'search/smart_search_page.dart';
import 'practice/practice_home_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // These are the 5 core tabs for our app
  final List<Widget> _pages = [
    const MathSolverPage(),
    const PhysicsHomePage(),
    const ChemistryPage(),
    const SmartSearchPage(),
    const PracticeHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OmniFormula Solver'),
        actions: [
          // Update check button — visible on all tabs
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Check for Updates',
            onPressed: () => UpdateService.checkForUpdate(context),
          ),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.calculate),
                      label: Text('Math'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.science),
                      label: Text('Physics'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.biotech),
                      label: Text('Chem'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.search),
                      label: Text('Search'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.quiz),
                      label: Text('Practice'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _pages[_selectedIndex]),
              ],
            )
          : _pages[_selectedIndex],
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calculate),
                  label: 'Math',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.science),
                  label: 'Physics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.biotech),
                  label: 'Chem',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.quiz),
                  label: 'Practice',
                ),
              ],
            ),
    );
  }
}