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
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Visualizer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Audio Visualizer",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Simulated audio levels",
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomPaint(
                painter: BarPainter(bars),
                child: Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: regenerate,
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text(
                  "Regenerate",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 30, 215, 96),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
          ),
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
    double barWidth = size.width / bars.length;

    for (int i = 0; i < bars.length; i++) {
      double barHeight = bars[i] * size.height * 0.8;
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color.fromARGB(255, 30, 215, 96),
            const Color.fromARGB(255, 30, 215, 96).withOpacity(0.3),
          ],
        ).createShader(Rect.fromLTWH(
          i * barWidth,
          size.height - barHeight,
          barWidth - 4,
          barHeight,
        ));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * barWidth + 2,
            size.height - barHeight,
            barWidth - 6,
            barHeight,
          ),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
