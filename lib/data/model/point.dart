class Point {
  Point({
    required this.x,
    required this.y,
    this.rssi = -1,
  });

  double x;
  double y;
  int? rssi;

  @override
  String toString() {
    
    return 'Point [rssi: $rssi]';
  }
}
