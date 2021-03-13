import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:utility_finder/models/utility.dart';

// TODO: replace http with https

// Fetches list of nearby utilities
Future<List<Utility>> fetchUtilities(
    double lat, double lon, double radius) async {
  http.Response response = await http.get(Uri.http(env['API_URL'], '/list', {
    "lat": lat.toString(),
    "lon": lon.toString(),
    "radius": radius.toString()
  }));

  if (response.statusCode != 200) {
    throw Exception('Failed to load utilities');
  }

  List<dynamic> data = jsonDecode(response.body);
  List<Utility> utilities = data.map((e) => Utility.fromJson(e)).toList();
  return utilities;
}
