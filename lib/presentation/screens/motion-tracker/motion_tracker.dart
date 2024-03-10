import 'dart:async';
import 'dart:developer';

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
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  bool _isScanning = false;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];

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
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
      log("Results");
      log(_scanResults.toString());
    }, onError: (e) {
      // Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      precacheImage(_imageProvider, context);
      await player.setSource(
        AssetSource(
          kBlipSound,
        ),
      );
      await player.setVolume(1);
      await player.resume();
      await player.setReleaseMode(ReleaseMode.loop);
      onScanPressed();
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

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      log(
        "System Devices Error: $e",
      );
    }
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

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  static TextStyle _computeTextStyle(int rssi) {
    if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700]);
    } else if (rssi >= -45)
      return TextStyle(
        color: Color.lerp(
          Colors.greenAccent[700],
          Colors.lightGreen,
          -(rssi + 35) / 10,
        ),
      );
    else if (rssi >= -55) {
      return TextStyle(
        color: Color.lerp(
          Colors.lightGreen,
          Colors.lime[600],
          -(rssi + 45) / 10,
        ),
      );
    } else if (rssi >= -65) {
      return TextStyle(
        color: Color.lerp(
          Colors.lime[600],
          Colors.amber,
          -(rssi + 55) / 10,
        ),
      );
    } else if (rssi >= -75) {
      return TextStyle(
        color: Color.lerp(
          Colors.amber,
          Colors.deepOrangeAccent,
          -(rssi + 65) / 10,
        ),
      );
    } else if (rssi >= -85) {
      return TextStyle(
        color: Color.lerp(
          Colors.deepOrangeAccent,
          Colors.redAccent,
          -(rssi + 75) / 10,
        ),
      );
    } else {
      /*code symmetry*/
      return const TextStyle(color: Colors.redAccent);
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
