class Point {
  Point({
    required this.remoteId,
    required this.x,
    required this.y,
    this.rssi = -1,
  });

  String remoteId;
  int x;
  int y;
  int? rssi;

  @override
  String toString() {
    return 'Point [remoteId: $remoteId,  rssi: $rssi, x: $x, y: $y]';
  }
}
