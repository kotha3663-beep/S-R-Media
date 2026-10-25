import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import 'game_over_screen.dart';

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  List<List<int>> _grid = List.generate(4, (_) => List.filled(4, 0));
  int _score = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _grid = List.generate(4, (_) => List.filled(4, 0));
      _score = 0;
      _isGameOver = false;
      _addNewTile();
      _addNewTile();
    });
  }

  void _addNewTile() {
    final emptyCells = <List<int>>[];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) emptyCells.add([i, j]);
      }
    }
    if (emptyCells.isNotEmpty) {
      final randomCell = emptyCells[(DateTime.now().millisecondsSinceEpoch % emptyCells.length)];
      _grid[randomCell[0]][randomCell[1]] = DateTime.now().millisecondsSinceEpoch % 10 == 0 ? 4 : 2;
    }
  }

  bool _canMove() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) return true;
        if (i < 3 && _grid[i][j] == _grid[i + 1][j]) return true;
        if (j < 3 && _grid[i][j] == _grid[i][j + 1]) return true;
      }
    }
    return false;
  }

  void _moveLeft() {
    for (int i = 0; i < 4; i++) {
      List<int> row = _grid[i].where((x) => x != 0).toList();
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j] == row[j + 1]) {
          row[j] *= 2;
          _score += row[j];
          row.removeAt(j + 1);
        }
      }
      while (row.length < 4) {
        row.add(0);
      }
      _grid[i] = row;
    }
  }

  void _moveRight() {
    for (int i = 0; i < 4; i++) {
      List<int> row = _grid[i].where((x) => x != 0).toList().reversed.toList();
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j] == row[j + 1]) {
          row[j] *= 2;
          _score += row[j];
          row.removeAt(j + 1);
        }
      }
      while (row.length < 4) {
        row.add(0);
      }
      _grid[i] = row.reversed.toList();
    }
  }

  void _moveUp() {
    for (int j = 0; j < 4; j++) {
      List<int> col = [];
      for (int i = 0; i < 4; i++) {
        if (_grid[i][j] != 0) col.add(_grid[i][j]);
      }
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          _score += col[i];
          col.removeAt(i + 1);
        }
      }
      while (col.length < 4) {
        col.add(0);
      }
      for (int i = 0; i < 4; i++) {
        _grid[i][j] = col[i];
      }
    }
  }

  void _moveDown() {
    for (int j = 0; j < 4; j++) {
      List<int> col = [];
      for (int i = 3; i >= 0; i--) {
        if (_grid[i][j] != 0) col.add(_grid[i][j]);
      }
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          _score += col[i];
          col.removeAt(i + 1);
        }
      }
      while (col.length < 4) {
        col.add(0);
      }
      for (int i = 3; i >= 0; i--) {
        _grid[i][j] = col[3 - i];
      }
    }
  }

  void _handleSwipe(DragEndDetails details) {
    if (_isGameOver) return;
    
    final velocity = details.velocity.pixelsPerSecond;
    if (velocity.dx.abs() > velocity.dy.abs()) {
      if (velocity.dx > 0) {
        _moveRight();
      } else {
        _moveLeft();
      }
    } else {
      if (velocity.dy > 0) {
        _moveDown();
      } else {
        _moveUp();
      }
    }
    
    setState(() {
      _addNewTile();
      if (!_canMove()) {
        _isGameOver = true;
        _showGameOver();
      }
    });
  }

  void _showGameOver() {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          gameId: '2048',
          gameName: isBn ? '২০৪৮' : '2048 Merge',
          score: _score,
          onRestart: _startNewGame,
          onExit: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2: return const Color(0xFFEEE4DA);
      case 4: return const Color(0xFFEDE0C8);
      case 8: return const Color(0xFFF2B179);
      case 16: return const Color(0xFFF59563);
      case 32: return const Color(0xFFF67C5F);
      case 64: return const Color(0xFFF65E3B);
      case 128: return const Color(0xFFEDCF72);
      case 256: return const Color(0xFFEDCC61);
      case 512: return const Color(0xFFEDC850);
      case 1024: return const Color(0xFFEDC53F);
      case 2048: return const Color(0xFFEDC22E);
      default: return const Color(0xFFCDC1B4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = LanguageService().currentLocale.languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isBn ? 'স্কোর: $_score' : 'Score: $_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(isBn ? 'সরাতে সোয়াইপ করুন' : 'Swipe to move', style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanEnd: _handleSwipe,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFBBADA0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    final row = index ~/ 4;
                    final col = index % 4;
                    final value = _grid[row][col];
                    return Container(
                      decoration: BoxDecoration(
                        color: value == 0 ? const Color(0xFFCDC1B4).withOpacity(0.35) : _getTileColor(value),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          value == 0 ? '' : '$value',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: value <= 4 ? const Color(0xFF776E65) : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
