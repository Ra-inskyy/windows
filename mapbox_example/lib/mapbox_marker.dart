import 'package:mapbox_gl/mapbox_gl.dart';

class MapboxMarker {
  final LatLng position;
  final String iconUrl;

  MapboxMarker({required this.position, required this.iconUrl});
}
