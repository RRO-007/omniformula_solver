import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/dashboard_screen.dart';

void main() {
  runApp(const OmniFormulaApp());
}

class OmniFormulaApp extends StatelessWidget {
  const OmniFormulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The base font for our scientific app
    final TextTheme scienceTextTheme = GoogleFonts.jetBrainsMonoTextTheme();

    return MaterialApp(
      title: 'OmniFormula Solver',
      debugShowCheckedModeBanner: false,

      // Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: scienceTextTheme.apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.black54),
        ),
      ),

      // Dark Theme (Formulia Style)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: scienceTextTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),

      // Automatically switches based on user's phone/PC settings
      themeMode: ThemeMode.dark,
      home: const DashboardScreen(),
    );
  }
}