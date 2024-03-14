class Point {
  Point({
    required this.remoteId,
    required this.x,
    required this.y,
    this.rssi = -1,
  });

  String remoteId;
  double x;
  double y;
  int? rssi;

  @override
  String toString() {
    
    return 'Point [rssi: $rssi, x: $x, y: $y]';
  }
}
