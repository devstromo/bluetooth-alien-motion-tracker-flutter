import 'package:bluetooth_alien_motion_tracker/config/config.dart';
import 'package:flutter/material.dart';

class DistanceDataContainer extends StatelessWidget {
  const DistanceDataContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      color: kDistanceContainerColor,
    );
  }
}