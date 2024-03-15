import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:bluetooth_alien_motion_tracker/data/data.dart';
import 'package:bluetooth_alien_motion_tracker/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionTracker extends StatefulWidget {
  const MotionTracker({super.key});

  @override
  State<MotionTracker> createState() => _MotionTrackerState();
}

class _MotionTrackerState extends State<MotionTracker> {
  GyroscopeEvent? _gyroscopeEvent;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Duration sensorInterval = SensorInterval.normalInterval;
  double _currentRotation = 0.0;
  late final ImageProvider _imageProvider;
  final player = AudioPlayer();
  final beep = AudioPlayer();
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  
  List<ScanResult> _scanResults = [];
  final _points = <Point>[];
  Map<String, Point> resultMap = <String, Point>{};

  @override
  void initState() {
    super.initState();
    _imageProvider = const AssetImage('assets/imgs/motion-marker-circle.png');

    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeEvent = event;
          });
          _updateRotation(event);
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                    "It seems that your device doesn't support Gyroscope Sensor",
                  ),
                );
              });
        },
        cancelOnError: true,
      ),
    );

    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      if (mounted) {
        setState(() {
          _adapterState = state;
          if (state == BluetoothAdapterState.on) {
            startBluetoothScanning();
          } else if (state == BluetoothAdapterState.off ||
              state == BluetoothAdapterState.turningOff) {
            stopScan();
          }
        });
      }
    });

    FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {
          final screenWidth = MediaQuery.of(context).size.width;
          final rangeStart = screenWidth * 0.15; // Start 15% from the left
          final rangeEnd = screenWidth * 0.85;
          // End 85% from the left, which is 70% of width
          log("Results");
          log(_scanResults.toString());
          // Create a map of new scan results for easy lookup
          final newResultsMap = {
            for (var item
                in _scanResults.where((element) => element.rssi > -75))
              item.device.remoteId.str: item
          };
          // final   filterResult =

          // Identify and remove points that are not in the new scan results
          _points.removeWhere(
              (point) => !newResultsMap.containsKey(point.remoteId));

          // Update existing points and add new points
          newResultsMap.forEach((id, result) {
            final existingPointIndex =
                _points.indexWhere((point) => point.remoteId == id);
            if (existingPointIndex != -1) {
              _points[existingPointIndex] = Point(
                remoteId: id,
                x: _points[existingPointIndex].x,
                y: mapRssiToScreenY(result.rssi, context),
                rssi: result.rssi,
              );
            } else {
              // Add new point
              _points.add(Point(
                remoteId: id,
                x: math.Random().nextDouble() * (rangeEnd - rangeStart) +
                    rangeStart,
                y: mapRssiToScreenY(result.rssi, context),
                rssi: result.rssi,
              ));
            }
          });

          if (_scanResults.isEmpty) {
            // Clear points if no results
            _points.clear();
          }
          log("Points");
          log(_points.toString());
          _updateBeep(_points);
        });
      }
    }, onError: (e) {
      log('Scan Error: $e');
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {      
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      precacheImage(_imageProvider, context);
      _setUpSounds();
      startBluetoothScanning();
    });
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    Future.delayed(Duration.zero, () async {
      await player.dispose();
    });
    _adapterStateStateSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  _setUpSounds() async {
    await player.setSource(
      AssetSource(
        kBlipSound,
      ),
    );
    await beep.setSource(
      AssetSource(
        kBeepSound,
      ),
    );
    await player.setVolume(1);
    await player.resume();
    await player.setReleaseMode(ReleaseMode.loop);

    await beep.setVolume(1);
    await beep.setReleaseMode(ReleaseMode.loop);
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

  Future<void> stopScan() {
    _points.clear();
    _scanResults.clear();
    _updateBeep(_points);
    return FlutterBluePlus.stopScan();
  }

  Future startBluetoothScanning() async {
    Future.delayed(
      const Duration(
        seconds: 5,
      ),
    );  
    try {
      await FlutterBluePlus.startScan(
        // timeout: const Duration(seconds: 15),
        continuousUpdates: true,
        androidUsesFineLocation: true,
      );
    } catch (e) {
      log(
        "Start Scan Error: $e",
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _updateBeep(List<Point> points) async {
    if (points.isNotEmpty) {
      await player.stop();
      await beep.resume();
    } else {
      await beep.stop();
      await player.resume();
    }
  }

  double mapRssiToScreenY(int rssi, BuildContext context) {
    // Assuming RSSI ranges from 0 to -75
    const double minRssi = -75;
    const double maxRssi = 0;

    // Screen height calculation
    double screenHeight =
        MediaQuery.of(context).size.width; // Use width due to landscape mode
    double offset = 50; // Adjust based on your UI needs

    // Map RSSI to screen height
    double y =
        ((rssi - minRssi) / (maxRssi - minRssi)) * (screenHeight - offset);

    return y;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [
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
            Text(
              'Points: ${_points.length}',
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
          child: Image(
            image: _imageProvider,
          ),
        ),
      ),
    ];
    // Add dynamic points to the stackChildren
    stackChildren.addAll(_points.map((point) {
      return PointMarker(
        x: point.x,
        y: point.y,
      );
    }).toList());

    stackChildren = [
      ...stackChildren,
      const Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: DistanceDataContainer(
          numbers: DistanceNumbers(),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}
