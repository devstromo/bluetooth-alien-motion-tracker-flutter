import 'package:bluetooth_alien_motion_tracker/config/config.dart';
import 'package:flutter/material.dart';

class DistanceDataContainer extends StatelessWidget {
  const DistanceDataContainer({
    super.key,
    required this.numbers,
  });

  final Widget numbers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      color: kDistanceContainerColor,
      child: Stack(
        children: [
          const Positioned(
            left: 60,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
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
          const Positioned(
            right: 60,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                'C.X. 56/36.53',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                      25,
                    ),
                  ),
                ),
                child: numbers,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
