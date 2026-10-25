import 'package:flutter/material.dart';

class DotConnectGame extends StatefulWidget {
  const DotConnectGame({super.key});

  @override
  State<DotConnectGame> createState() => _DotConnectGameState();
}

class _DotConnectGameState extends State<DotConnectGame> {
  final int gridSize = 5;
  final Map<String, List<Offset>> _paths = {};
  bool _isDrawing = false;
  String? _activeColor;

  void _onPanStart(DragStartDetails details, Size size) {
    final cellSize = size.width / gridSize;
    final x = (details.localPosition.dx / cellSize).floor();
    final y = (details.localPosition.dy / cellSize).floor();

    if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
      String? dotColor;
      if ((x == 0 && y == 0) || (x == 4 && y == 4)) dotColor = 'red';
      if ((x == 4 && y == 0) || (x == 0 && y == 4)) dotColor = 'blue';

      if (dotColor != null) {
        setState(() {
          _activeColor = dotColor;
          _paths[dotColor] = [Offset(x.toDouble(), y.toDouble())];
          _isDrawing = true;
        });
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (!_isDrawing || _activeColor == null) return;
    final cellSize = size.width / gridSize;
    
    final x = (details.localPosition.dx / cellSize).floor();
    final y = (details.localPosition.dy / cellSize).floor();
    final newPoint = Offset(x.toDouble(), y.toDouble());

    if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
      List<Offset> currentPath = _paths[_activeColor]!;
      if (!currentPath.contains(newPoint)) {
        final lastPoint = currentPath.last;
        if ((lastPoint.dx - newPoint.dx).abs() + (lastPoint.dy - newPoint.dy).abs() == 1) {
          bool collision = false;
          for (var path in _paths.values) {
            if (path.contains(newPoint) && newPoint != Offset(0, 0) && newPoint != Offset(4, 4) && newPoint != Offset(4, 0) && newPoint != Offset(0, 4)) {
              collision = true;
            }
          }
          
          if (!collision) {
            setState(() {
              currentPath.add(newPoint);
            });
          }
        }
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDrawing = false;
      _activeColor = null;
    });
    _checkWin();
  }

  void _checkWin() {
    bool allConnected = true;
    if (!_paths.containsKey('red') || !_paths['red']!.contains(const Offset(4, 4))) allConnected = false;
    if (!_paths.containsKey('blue') || !_paths['blue']!.contains(const Offset(0, 4))) allConnected = false;

    if (allConnected) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('অভিনন্দন!'),
          content: const Text('আপনি সফলভাবে ডটগুলো কানেক্ট করেছেন।'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _paths.clear();
                });
              },
              child: const Text('আবার খেলুন'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dot Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _paths.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxWidth);
            return Center(
              child: GestureDetector(
                onPanStart: (details) => _onPanStart(details, size),
                onPanUpdate: (details) => _onPanUpdate(details, size),
                onPanEnd: _onPanEnd,
                child: CustomPaint(
                  size: size,
                  painter: DotConnectPainter(
                    gridSize: gridSize,
                    paths: _paths,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DotConnectPainter extends CustomPainter {
  final int gridSize;
  final Map<String, List<Offset>> paths;

  DotConnectPainter({required this.gridSize, required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / gridSize;
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = cellSize * 0.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var entry in paths.entries) {
      linePaint.color = entry.key == 'red' ? Colors.red : Colors.blue;
      final path = Path();
      if (entry.value.isNotEmpty) {
        path.moveTo(entry.value.first.dx * cellSize + cellSize / 2, entry.value.first.dy * cellSize + cellSize / 2);
        for (int i = 1; i < entry.value.length; i++) {
          path.lineTo(entry.value[i].dx * cellSize + cellSize / 2, entry.value[i].dy * cellSize + cellSize / 2);
        }
        canvas.drawPath(path, linePaint);
      }
    }

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        final center = Offset(i * cellSize + cellSize / 2, j * cellSize + cellSize / 2);
        
        if ((i == 0 && j == 0) || (i == 4 && j == 4)) {
          dotPaint.color = Colors.red;
          canvas.drawCircle(center, cellSize * 0.3, dotPaint);
        } else if ((i == 4 && j == 0) || (i == 0 && j == 4)) {
          dotPaint.color = Colors.blue;
          canvas.drawCircle(center, cellSize * 0.3, dotPaint);
        } else {
          dotPaint.color = Colors.grey.shade400;
          canvas.drawCircle(center, cellSize * 0.15, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
