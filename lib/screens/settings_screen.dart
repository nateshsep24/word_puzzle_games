import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dark Theme'),
            trailing: Switch(
              value: themeProvider.isDarkTheme,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          ListTile(
            title: Text('Enable Background Music'),
            trailing: Switch(
              value: themeProvider.isMusicEnabled,
              onChanged: (value) {
                themeProvider.toggleMusic();
              },
            ),
          ),
        ],
      ),
    );
  }
}
