import 'package:latlong2/latlong.dart';

class LocationUtils {
  static double calculateDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  static double convertToMiles(double kilometers) {
    return kilometers * 0.621371;
  }
}