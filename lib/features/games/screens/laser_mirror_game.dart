import 'package:flutter/material.dart';
import 'dart:math' as math;

class LaserMirrorGame extends StatefulWidget {
  const LaserMirrorGame({super.key});

  @override
  State<LaserMirrorGame> createState() => _LaserMirrorGameState();
}

class _LaserMirrorGameState extends State<LaserMirrorGame> {
  int gridSize = 5;
  int selectedMirrorRow = 2;
  int selectedMirrorCol = 2;
  double angle = 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laser & Mirrors')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('আয়না ঘুরিয়ে লেজারকে লক্ষ্যে পৌঁছান।', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: LaserPainter(gridSize: gridSize, mirrorRow: selectedMirrorRow, mirrorCol: selectedMirrorCol, angle: angle),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Slider(
              value: angle,
              min: 0,
              max: 180,
              divisions: 4,
              label: '${angle.toInt()}°',
              onChanged: (val) {
                setState(() {
                  angle = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LaserPainter extends CustomPainter {
  final int gridSize;
  final int mirrorRow;
  final int mirrorCol;
  final double angle;

  LaserPainter({required this.gridSize, required this.mirrorRow, required this.mirrorCol, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / gridSize;
    final paint = Paint()..color = Colors.blueAccent..strokeWidth = 3..style = PaintingStyle.stroke;

    for (int i = 0; i <= gridSize; i++) {
      canvas.drawLine(Offset(i * cellSize, 0), Offset(i * cellSize, size.height), Paint()..color = Colors.grey.shade300..strokeWidth = 1);
      canvas.drawLine(Offset(0, i * cellSize), Offset(size.width, i * cellSize), Paint()..color = Colors.grey.shade300..strokeWidth = 1);
    }

    final targetCenter = Offset((gridSize - 0.5) * cellSize, (gridSize - 0.5) * cellSize);
    canvas.drawCircle(targetCenter, cellSize * 0.3, Paint()..color = Colors.red);

    final mirrorCenter = Offset(mirrorCol * cellSize + cellSize / 2, mirrorRow * cellSize + cellSize / 2);
    final rad = angle * math.pi / 180;
    final mirrorLine = Path()
      ..moveTo(mirrorCenter.dx - math.cos(rad) * cellSize / 2, mirrorCenter.dy - math.sin(rad) * cellSize / 2)
      ..lineTo(mirrorCenter.dx + math.cos(rad) * cellSize / 2, mirrorCenter.dy + math.sin(rad) * cellSize / 2);
    canvas.drawPath(mirrorLine, Paint()..color = Colors.black..strokeWidth = 4);

    canvas.drawLine(
      Offset(0, cellSize / 2),
      mirrorCenter,
      paint..color = Colors.redAccent,
    );
    
    final normalRad = rad + math.pi / 2;
    final incidentRad = 0.0;
    final reflectedRad = 2 * normalRad - incidentRad;
    
    final endX = mirrorCenter.dx + math.cos(reflectedRad) * size.width;
    final endY = mirrorCenter.dy + math.sin(reflectedRad) * size.width;
    
    canvas.drawLine(mirrorCenter, Offset(endX, endY), paint..color = Colors.redAccent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
