import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapboxApi {
  static const String _apiKey = 'sk.eyJ1Ijoic21pbHloeGMiLCJhIjoiY2x3amR3ZXZtMHNsdjJpcGZ2dW1xcDlwNiJ9.no1_LQIVdKO2XQfkRdlHuw';

  static Future<Map<String, dynamic>> getDirections(LatLng start, LatLng end) async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$_apiKey';
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }
}
