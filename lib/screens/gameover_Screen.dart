import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int levelsCleared;
  final int wordsFound;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  const GameOverScreen({super.key, 
    required this.levelsCleared,
    required this.wordsFound,
    required this.onPlayAgain,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Over"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Game Over!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Levels Cleared: $levelsCleared",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Words Found: $wordsFound",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print("Play Again button pressed"); // Debugging log
                onPlayAgain(); // Trigger Play Again
              },
              child: Text("Play Again"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("Home button pressed"); // Debugging log
                onHome(); // Trigger Home
              },
              child: Text("Home"),
            ),
          ],
        ),
      ),
    );
  }
}
