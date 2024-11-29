import 'package:flutter/material.dart';
import 'word_search_screen.dart';
import 'anagram_screen.dart';
import 'hangman_screen.dart';
import 'word_jumble_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Word Puzzle Games"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            GameCard(
              title: "Word Search",
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WordSearchScreen()),
                );
              },
            ),
            GameCard(
              title: "Anagrams",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnagramScreen()),
                );
              },
            ),
            GameCard(
              title: "Hangman",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HangmanScreen()),
                );
              },
            ),
            GameCard(
              title: "Word Jumble",
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WordJumbleScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const GameCard({super.key, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
