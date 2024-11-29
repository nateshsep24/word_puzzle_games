import 'package:flutter/material.dart';

void main() {
  runApp(WordJumbleGame());
}

class WordJumbleGame extends StatelessWidget {
  const WordJumbleGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WordJumbleScreen(),
    );
  }
}

class WordJumbleScreen extends StatefulWidget {
  const WordJumbleScreen({super.key});

  @override
  _WordJumbleScreenState createState() => _WordJumbleScreenState();
}

class _WordJumbleScreenState extends State<WordJumbleScreen> {
  final String originalWord = "FLUTTER";
  late List<String> shuffledLetters;
  String input = "";

  @override
  void initState() {
    super.initState();
    shuffledLetters = originalWord.split("")..shuffle();
  }

  void checkAnswer() {
    if (input == originalWord) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You solved the puzzle!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
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
      appBar: AppBar(title: Text("Word Jumble")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Unscramble the letters:", style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text(shuffledLetters.join(" "), style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          TextField(
            onChanged: (value) => input = value.toUpperCase(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your answer",
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: checkAnswer, child: Text("Submit")),
        ],
      ),
    );
  }
}
