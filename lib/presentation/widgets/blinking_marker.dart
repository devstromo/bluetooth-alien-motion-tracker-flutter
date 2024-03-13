import 'dart:async';

import 'package:flutter/material.dart';

import 'blurred_painter.dart';

class BlinkingMarker extends StatefulWidget {
  const BlinkingMarker({super.key});

  @override
  State<BlinkingMarker> createState() => _BlinkingMarkerState();
}

class _BlinkingMarkerState extends State<BlinkingMarker> {
  double _opacity = 1.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.0 : 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration:
          const Duration(milliseconds: 500), // Adjust fade duration if you like
      child: CustomPaint(
        size: const Size(90, 90), // Size of the circle
        painter: BlurredCirclePainter(),
      ),
    );
  }
}
