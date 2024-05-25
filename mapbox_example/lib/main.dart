import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'custom_mapbox_map.dart';
import 'mapbox_marker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mapbox Complex Example'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Mapbox Map with Route and Markers:'),
                SizedBox(height: 20),
                CustomMapboxMap(
                  center: LatLng(40.7128, -74.0060),
                  zoom: 12,
                  markers: [
                    MapboxMarker(
                      position: LatLng(40.7128, -74.0060),
                      iconUrl: 'assets/marker.png',
                    ),
                    MapboxMarker(
                      position: LatLng(40.730610, -73.935242),
                      iconUrl: 'assets/marker.png',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
