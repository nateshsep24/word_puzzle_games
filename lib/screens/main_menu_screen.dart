import 'package:flutter/material.dart';
import 'dart:async';
import 'word_search_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late Timer _timer;
  int _colorIndex = 0;

  final List<List<Color>> _gradientColors = [
    [Colors.blue, Colors.purple],
    [Colors.pink, Colors.orange],
    [Colors.green, Colors.teal],
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _colorIndex = (_colorIndex + 1) % _gradientColors.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: Colors.black),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: AnimatedContainer(
          duration: Duration(seconds: 3),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradientColors[_colorIndex],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                "Word Search Game",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              // Play Now Button
              _buildMenuButton(
                context,
                title: "Play Now",
                icon: Icons.play_arrow,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordSearchScreen()),
                  );
                },
              ),
              // Settings Button
              _buildMenuButton(
                context,
                title: "Settings",
                icon: Icons.settings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              // Leaderboard Button
              _buildMenuButton(
                context,
                title: "Leaderboard",
                icon: Icons.leaderboard,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
