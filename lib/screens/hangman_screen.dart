import 'package:flutter/material.dart';

void main() {
  runApp(HangmanGame());
}

class HangmanGame extends StatelessWidget {
  const HangmanGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HangmanScreen(),
    );
  }
}

class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});

  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final String wordToGuess = "FLUTTER";
  Set<String> guessedLetters = {};
  int remainingGuesses = 6;

  String get displayedWord {
    return wordToGuess
        .split("")
        .map((letter) => guessedLetters.contains(letter) ? letter : "_")
        .join(" ");
  }

  void guessLetter(String letter) {
    if (!guessedLetters.contains(letter)) {
      setState(() {
        guessedLetters.add(letter);
        if (!wordToGuess.contains(letter)) {
          remainingGuesses--;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hangman")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayedWord,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text("Remaining Guesses: $remainingGuesses"),
          SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("").map((letter) {
              return ElevatedButton(
                onPressed: guessedLetters.contains(letter) || remainingGuesses == 0
                    ? null
                    : () => guessLetter(letter),
                child: Text(letter),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          if (remainingGuesses == 0)
            Text("Game Over! The word was $wordToGuess.",
                style: TextStyle(color: Colors.red, fontSize: 18)),
          if (displayedWord.replaceAll(" ", "") == wordToGuess)
            Text("Congratulations! You guessed the word!",
                style: TextStyle(color: Colors.green, fontSize: 18)),
        ],
      ),
    );
  }
}
