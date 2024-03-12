import 'dart:ui';

import 'package:flutter/material.dart';

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
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              50,
            ),
          ),
        ),
      ),
    );
  }
}
