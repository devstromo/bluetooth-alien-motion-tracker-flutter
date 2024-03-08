import 'dart:async';
import 'dart:math';

import 'package:bluetooth_alien_motion_tracker/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionTracker extends StatefulWidget {
  const MotionTracker({super.key});

  @override
  State<MotionTracker> createState() => _MotionTrackerState();
}

class _MotionTrackerState extends State<MotionTracker> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  GyroscopeEvent? _gyroscopeEvent;
  int? _gyroscopeLastInterval;
  DateTime? _gyroscopeUpdateTime;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Duration sensorInterval = SensorInterval.normalInterval;
  double _currentRotation = 0.0;
  late final ImageProvider _imageProvider;

  @override
  void initState() {
    super.initState();
    _imageProvider = const AssetImage('assets/imgs/inner-circle-thin.png');

    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          setState(() {
            _gyroscopeEvent = event;
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                _gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
          });
          _gyroscopeUpdateTime = now;
          _updateRotation(event);
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      precacheImage(_imageProvider, context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  // Add this to your existing Gyroscope event listener
  _updateRotation(GyroscopeEvent event) {
    if (event.x.abs() > 0.001) {
      // Update the rotation angle based on the x value of the gyroscope.
      // You might want to scale the x value or use a different function to calculate the rotation angle
      // depending on how sensitive you want the rotation to be to the gyroscope's readings.
      setState(() {
        _currentRotation += event
            .x; // This is a simple example, you'll likely want to scale and/or limit this value
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  'Motion Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Gyroscope',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'x: ${_gyroscopeEvent?.x.toStringAsFixed(6) ?? '?'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'y: ${_gyroscopeEvent?.y.toStringAsFixed(1) ?? '?'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'z: ${_gyroscopeEvent?.z.toStringAsFixed(1) ?? '?'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_gyroscopeLastInterval?.toString() ?? '?'} ms',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: _currentRotation, // Use your current rotation here
              child: Image(image: _imageProvider,
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DistanceDataContainer(
              numbers: DistanceNumbers(),
            ),
          )
        ],
      ),
    );
  }
}
