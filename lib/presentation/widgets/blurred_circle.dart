import 'package:flutter/material.dart';

import 'blurred_painter.dart';

class BlurredCircle extends StatelessWidget {
  const BlurredCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(
        90,
        90,
      ), // Size of the circle
      painter: BlurredCirclePainter(),
    );
  }
}

