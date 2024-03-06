import 'package:bluetooth_alien_motion_tracker/config/config.dart';
import 'package:flutter/material.dart';

class DistanceNumbers extends StatelessWidget {
  const DistanceNumbers({
    super.key,
    this.distance = 0.0,
  });

  final double distance;

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '00',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: kDistanceNumbersColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8.0,
          ),
          child: Text(
            '00\nm',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: kDistanceNumbersColor,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
