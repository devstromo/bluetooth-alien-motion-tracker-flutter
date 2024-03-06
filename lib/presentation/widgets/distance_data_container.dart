import 'package:bluetooth_alien_motion_tracker/config/config.dart';
import 'package:flutter/material.dart';

class DistanceDataContainer extends StatelessWidget {
  const DistanceDataContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: kToolbarHeight,
      color: kDistanceContainerColor,
      child: const Stack(
        children: [
          Center(
            child: Text('Motion Tracker'),
          )
        ],
      ),
    );
  }
}
