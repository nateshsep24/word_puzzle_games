import 'package:flutter/material.dart';
import 'dart:math';

class WordSearchScreen extends StatefulWidget {
  @override
  _WordSearchScreenState createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  final int gridSize = 8; // Grid size
  late List<List<String>> grid;
  late List<String> wordList;
  late List<Offset> selectedCells;
  String selectedWord = "";
  int wordsFound = 0;
  late List<String> foundWords;
  bool isSelecting = false;
  String? selectionDirection;

  @override
  void initState() {
    super.initState();
    _generateNewLevel();
  }

  void _generateNewLevel() {
    setState(() {
      wordsFound = 0;
      wordList = _generateWords();
      grid = _generateGrid(wordList);
      selectedCells = [];
      foundWords = [];
    });
  }

  List<String> _generateWords() {
    return ["APPLE", "ORANGE", "BANANA", "GRAPE", "PEACH", "CHERRY"];
  }

  List<List<String>> _generateGrid(List<String> words) {
    List<List<String>> tempGrid =
    List.generate(gridSize, (_) => List.generate(gridSize, (_) => ""));
    Random random = Random();

    for (String word in words) {
      bool placed = false;

      while (!placed) {
        int row = random.nextInt(gridSize);
        int col = random.nextInt(gridSize);
        int direction = random.nextInt(4); // 0: horizontal, 1: vertical, 2: diagonal, 3: reverse

        if (_canPlaceWord(tempGrid, word, row, col, direction)) {
          _placeWord(tempGrid, word, row, col, direction);
          placed = true;
        }
      }
    }

    // Fill remaining cells with random letters
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (tempGrid[row][col] == "") {
          tempGrid[row][col] = String.fromCharCode(random.nextInt(26) + 65);
        }
      }
    }
    return tempGrid;
  }

  bool _canPlaceWord(List<List<String>> tempGrid, String word, int row, int col, int direction) {
    int wordLength = word.length;

    if (direction == 0 && col + wordLength > gridSize) return false; // Horizontal
    if (direction == 1 && row + wordLength > gridSize) return false; // Vertical
    if (direction == 2 && (row + wordLength > gridSize || col + wordLength > gridSize))
      return false; // Diagonal
    if (direction == 3 && col - wordLength < -1) return false; // Reverse

    for (int i = 0; i < wordLength; i++) {
      int r = row + (direction == 1 || direction == 2 ? i : 0);
      int c = col +
          (direction == 0
              ? i
              : direction == 3
              ? -i
              : direction == 2
              ? i
              : 0);

      if (tempGrid[r][c] != "" && tempGrid[r][c] != word[i]) return false;
    }

    return true;
  }

  void _placeWord(List<List<String>> tempGrid, String word, int row, int col, int direction) {
    for (int i = 0; i < word.length; i++) {
      int r = row + (direction == 1 || direction == 2 ? i : 0);
      int c = col +
          (direction == 0
              ? i
              : direction == 3
              ? -i
              : direction == 2
              ? i
              : 0);

      tempGrid[r][c] = word[i];
    }
  }

  void _onPanStart(Offset position, double cellSize) {
    setState(() {
      isSelecting = true;
      selectedCells = [_getCellAtPosition(position, cellSize)];
      selectedWord = "";
    });
  }

  void _onPanUpdate(Offset position, double cellSize) {
    setState(() {
      Offset cell = _getCellAtPosition(position, cellSize);

      if (selectedCells.isEmpty) {
        // First cell in the selection
        selectedCells.add(cell);
        return;
      }

      if (!selectedCells.contains(cell)) {
        // Ensure the swipe direction is consistent
        if (selectedCells.length == 1) {
          // Calculate the direction for the first two cells
          selectionDirection = _calculateDirection(selectedCells.first, cell);
        } else if (!_isAlignedWithDirection(
            selectionDirection!, selectedCells.last, cell)) {
          return; // Ignore the cell if it doesn't align with the direction
        }

        selectedCells.add(cell);

        // Generate the selected word dynamically
        selectedWord = selectedCells.map((selectedCell) {
          int row = selectedCell.dy.toInt();
          int col = selectedCell.dx.toInt();
          return grid[row][col];
        }).join();
      }
    });
  }
  String _calculateDirection(Offset start, Offset end) {
    int dx = (end.dx - start.dx).toInt();
    int dy = (end.dy - start.dy).toInt();

    if (dx == 0 && dy != 0) return "vertical"; // Vertical swipe
    if (dy == 0 && dx != 0) return "horizontal"; // Horizontal swipe
    if (dx.abs() == dy.abs()) return "diagonal"; // Diagonal swipe

    return "invalid"; // Any other swipe is invalid
  }
  bool _isAlignedWithDirection(String direction, Offset lastCell, Offset newCell) {
    int dx = (newCell.dx - lastCell.dx).toInt();
    int dy = (newCell.dy - lastCell.dy).toInt();

    if (direction == "horizontal") return dy == 0 && dx.abs() == 1;
    if (direction == "vertical") return dx == 0 && dy.abs() == 1;
    if (direction == "diagonal") return dx.abs() == dy.abs() && dx.abs() == 1;

    return false;
  }


  void _onPanEnd() {
    setState(() {
      isSelecting = false;
      if (wordList.contains(selectedWord)) {
        wordList.remove(selectedWord);
        foundWords.add(selectedWord);
        wordsFound++;
      }
      selectedCells = [];
      selectedWord = "";
      selectionDirection = null; // Reset direction for the next selection
    });
  }


  Offset _getCellAtPosition(Offset position, double cellSize) {
    int col = (position.dx / cellSize).floor();
    int row = (position.dy / cellSize).floor();
    return Offset(col.toDouble(), row.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    double gridSizePx = MediaQuery.of(context).size.width * 0.9;
    double cellSize = gridSizePx / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text("Word Search"),
      ),
      body: Column(
        children: [
          Text("Words Found: $wordsFound / ${wordList.length + foundWords.length}"),
          SizedBox(
            height: gridSizePx,
            width: gridSizePx,
            child: GestureDetector(
              onPanStart: (details) => _onPanStart(details.localPosition, cellSize),
              onPanUpdate: (details) => _onPanUpdate(details.localPosition, cellSize),
              onPanEnd: (_) => _onPanEnd(),
              child: CustomPaint(
                painter: WordSearchPainter(grid, gridSize, selectedCells, foundWords),
                size: Size(gridSizePx, gridSizePx),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: wordList.map((word) => Chip(label: Text(word))).toList(),
          )
        ],
      ),
    );
  }
}

class WordSearchPainter extends CustomPainter {
  final List<List<String>> grid;
  final int gridSize;
  final List<Offset> selectedCells;
  final List<String> foundWords;
  final double spacing;

  WordSearchPainter(this.grid, this.gridSize, this.selectedCells, this.foundWords, {this.spacing = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    double cellSize = (size.width - (gridSize - 1) * spacing) / gridSize;  // Adjusting cell size with spacing

    Paint gridPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    Paint selectedPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw grid background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Draw cells and letters
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        // Adjust cell position considering the spacing
        double xPos = col * (cellSize + spacing);
        double yPos = row * (cellSize + spacing);
        Rect cellRect = Rect.fromLTWH(xPos, yPos, cellSize, cellSize);

        // Highlight selected cells
        if (selectedCells.contains(Offset(col.toDouble(), row.toDouble()))) {
          canvas.drawRect(cellRect, selectedPaint);
        }

        // Draw grid borders
        canvas.drawRect(cellRect, gridPaint);

        // Draw letters in the cells
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: grid[row][col],
            style: TextStyle(color: Colors.black, fontSize: cellSize * 0.5),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            cellRect.center.dx - textPainter.width / 2,
            cellRect.center.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

