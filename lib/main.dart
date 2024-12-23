import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'screens/tabs_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100], 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          titleTextStyle: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.teal,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.lato(),
        ),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const TabsScreen(),
    );
  }
}
