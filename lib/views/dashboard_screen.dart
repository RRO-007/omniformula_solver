import 'package:flutter/material.dart';
import 'math_solver_page.dart';
import 'physics/physics_solver_page.dart';
import 'chemistry/periodic_table_page.dart';
import 'tools/unit_converter_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // These are the 4 core tabs for our app
  final List<Widget> _pages = [
    const MathSolverPage(),
    const PhysicsSolverPage(),
    const PeriodicTablePage(),
    const ScientificToolsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Check if the screen is wide (Desktop/Web) or narrow (Mobile)
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OmniFormula Solver'),
      ),
      // On Desktop, use a side Navigation Rail. On Mobile, use a Bottom Bar.
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
                    NavigationRailDestination(icon: Icon(Icons.calculate), label: Text('Math')),
                    NavigationRailDestination(icon: Icon(Icons.science), label: Text('Physics')),
                    NavigationRailDestination(icon: Icon(Icons.biotech), label: Text('Chem')),
                    NavigationRailDestination(icon: Icon(Icons.build), label: Text('Tools')),
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
                BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Math'),
                BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Physics'),
                BottomNavigationBarItem(icon: Icon(Icons.biotech), label: 'Chem'),
                BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
              ],
            ),
    );
  }
}