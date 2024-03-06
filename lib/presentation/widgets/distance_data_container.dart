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
      child: Stack(
        children: [
          const Positioned(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'F.E.M.S. 5.327.25',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 100,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: const Text('Motion Tracker'),
            ),
          ),
        ],
      ),
    );
  }
}
