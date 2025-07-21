import 'package:flutter/material.dart';
import 'screens/login_register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color primaryRed = Color(0xFFA6193C);
  static const Color accentRed = Color(0xFFCC1F4A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acesso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryRed,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            primaryRed.value,
            {
              50: primaryRed.withOpacity(0.05),
              100: primaryRed.withOpacity(0.1),
              200: primaryRed.withOpacity(0.2),
              300: primaryRed.withOpacity(0.3),
              400: primaryRed.withOpacity(0.4),
              500: primaryRed,
              600: accentRed,
              700: accentRed,
              800: accentRed,
              900: accentRed,
            },
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: accentRed),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: primaryRed),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryRed,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: LoginRegisterScreen(),
    );
  }
}
