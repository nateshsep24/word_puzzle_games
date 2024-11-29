import 'package:flutter/material.dart';
import 'dart:math';

class AnagramScreen extends StatefulWidget {
  const AnagramScreen({super.key});

  @override
  _AnagramScreenState createState() => _AnagramScreenState();
}

class _AnagramScreenState extends State<AnagramScreen> {
  final List<String> words = ["FLUTTER", "DEVELOPER", "WIDGET", "DART", "PUZZLE"];
  late String selectedWord;
  late List<String> shuffledWord;
  String userInput = "";

  @override
  void initState() {
    super.initState();
    _generateNewWord();
  }

  void _generateNewWord() {
    selectedWord = words[Random().nextInt(words.length)];
    shuffledWord = selectedWord.split("")..shuffle();
    userInput = "";
  }

  void _checkAnswer() {
    if (userInput.toUpperCase() == selectedWord) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You guessed the word!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _generateNewWord();
                });
              },
              child: Text("Next Word"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incorrect! Try Again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anagrams"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Unscramble the letters:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              shuffledWord.join(" "),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            SizedBox(height: 30),
            TextField(
              onChanged: (value) {
                setState(() {
                  userInput = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your answer",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
