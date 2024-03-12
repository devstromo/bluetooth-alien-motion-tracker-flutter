import 'package:flutter/material.dart';

import 'blurred_circle.dart';

class PointMarker extends StatelessWidget {
  const PointMarker({
    super.key,
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: y,
      left: x,
      child: BlurredCircle(),
    );
  }
}
