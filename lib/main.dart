import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_menu_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: WordSearchApp(),
    ),
  );
}

class WordSearchApp extends StatelessWidget {
  const WordSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Search Game',
      theme: themeProvider.currentTheme, // Use the current theme from ThemeProvider
      home: MainMenuScreen(),
    );
  }
}
