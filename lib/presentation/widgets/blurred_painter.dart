import 'package:flutter/material.dart';

class BlurredCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint
    Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(1), // Center of the circle is fully opaque
          Colors.white.withOpacity(0), // Edges of the circle are transparent
        ],
        stops: const [
          // 0.5,
          0.3,
          0.9,
        ], // Adjust these stops for your needs
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ))
      ..maskFilter =
          const MaskFilter.blur(BlurStyle.normal, 10.0); // Adjust blur radius

    // Draw the circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // Circle center
      size.width / 2, // Radius
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
