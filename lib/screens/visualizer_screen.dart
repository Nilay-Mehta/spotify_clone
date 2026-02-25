import 'package:flutter/material.dart';
import 'dart:math';

class VisualizerScreen extends StatefulWidget {
  const VisualizerScreen({super.key});

  @override
  State<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen> {
  List<double> bars = List.generate(20, (index) => Random().nextDouble());

  void regenerate() {
    setState(() {
      bars = List.generate(20, (index) => Random().nextDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Visualizer"),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: BarPainter(bars),
              child: Container(),
            ),
          ),
          ElevatedButton(
            onPressed: regenerate,
            child: const Text("Refresh"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final List<double> bars;

  BarPainter(this.bars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green;

    double barWidth = size.width / bars.length;

    for (int i = 0; i < bars.length; i++) {
      double barHeight = bars[i] * size.height;

      canvas.drawRect(
        Rect.fromLTWH(
          i * barWidth,
          size.height - barHeight,
          barWidth - 4,
          barHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}