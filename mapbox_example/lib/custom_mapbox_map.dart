import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'mapbox_api.dart';
import 'mapbox_marker.dart';

class CustomMapboxMap extends StatefulWidget {
  final LatLng center;
  final double zoom;
  final List<MapboxMarker> markers;

  CustomMapboxMap({required this.center, required this.zoom, this.markers = const []});

  @override
  _CustomMapboxMapState createState() => _CustomMapboxMapState();
}

class _CustomMapboxMapState extends State<CustomMapboxMap> {
  MapboxMapController? _mapController;
  List<List<dynamic>> _routeCoordinates = [];

   @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    if (widget.markers.length >= 2) {
      try {
        final response = await MapboxApi.getDirections(widget.markers[0].position, widget.markers[1].position);
        final List<dynamic> coordinates = response['routes'][0]['geometry']['coordinates'];

        setState(() {
          _routeCoordinates = coordinates.map((coord) => [coordinates[0], coordinates[1]]).toList();
        });

        if (_mapController != null) {
          _addRoute();
        }
      } catch (e) {
        print('Error fetching directions: $e');
      }
    }
  }

  Future<void> _addRoute() async {
    if (_mapController == null || _routeCoordinates.isEmpty) return;

    

    await _mapController!.addLineLayer(
      'route',
      'route',
      LineLayerProperties(
        lineColor: 'blue',
        lineWidth: 5,
      ),
    );
  }

  Future<String> _loadMarkerIcon(String iconUrl) async {
    final byteData = await rootBundle.load(iconUrl);
    final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    final image = data!.buffer.asUint8List();
    final id = iconUrl; // Using the icon URL as a unique ID for simplicity
    await _mapController!.addImage(id, image);
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,  // Adjust the height as needed
      child: MapboxMap(
        accessToken: 'sk.eyJ1Ijoic21pbHloeGMiLCJhIjoiY2x3amR3ZXZtMHNsdjJpcGZ2dW1xcDlwNiJ9.no1_LQIVdKO2XQfkRdlHuw',
        initialCameraPosition: CameraPosition(
          target: widget.center,
          zoom: widget.zoom,
        ),
        onMapCreated: (MapboxMapController controller) async {
          _mapController = controller;
          for (var marker in widget.markers) {
            final icon = await _loadMarkerIcon(marker.iconUrl);
            _mapController!.addSymbol(
              SymbolOptions(
                geometry: marker.position,
                iconImage: icon,
                iconSize: 1.5,
              ),
            );
          }
          if (_routeCoordinates.isNotEmpty) {
            _addRoute();
          }
        },
      ),
    );
  }
}
