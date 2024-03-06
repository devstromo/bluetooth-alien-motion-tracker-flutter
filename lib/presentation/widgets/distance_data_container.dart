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
          const Positioned(
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
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
                child: const Row(
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
