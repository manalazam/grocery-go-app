import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const GroceryGoApp());
}

class GroceryGoApp extends StatelessWidget {
  const GroceryGoApp({super.key});

  static const Color kGreen = Color.fromARGB(255, 11, 71, 33);
  static const Color kGreenLight = Color.fromARGB(255, 9, 66, 30);
  static const Color kGreenSurface = Color(0xFFF0FDF4);
  static const Color kOrange = Color(0xFFEA580C);
  static const Color kBg = Color(0xFFF8FAF8);
  static const Color kText = Color(0xFF0D1F14);
  static const Color kTextMuted = Color(0xFF6B7C72);
  static const Color kBorder = Color(0xFFE2EAE5);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GroceryGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kGreen,
          primary: kGreen,
          secondary: kOrange,
          surface: Colors.white,
          background: kBg,
        ),
        scaffoldBackgroundColor: kBg,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: kText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
          iconTheme: IconThemeData(color: kText),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF4F8F5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kGreen, width: 2),
          ),
          labelStyle: const TextStyle(color: kTextMuted, fontSize: 14),
          hintStyle: const TextStyle(color: Color(0xFFADBDB6), fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: kBorder),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return const Color.fromARGB(255, 8, 61, 27);
            return Colors.transparent;
          }),
          side: const BorderSide(color: Color(0xFFBDCFC6), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}