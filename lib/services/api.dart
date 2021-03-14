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
    throw Exception('Failed to fetch utilities');
  }

  List<dynamic> data = jsonDecode(response.body);
  List<Utility> utilities = data.map((e) => Utility.fromJson(e)).toList();
  return utilities;
}

// Fetches utility by id
Future<Utility> fetchUtilityByID(String id) async {
  http.Response response = await http.get(
    Uri.http(env['API_URL'], '/utility$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load utility');
  }

  Map<String, dynamic> data = jsonDecode(response.body);
  Utility utility = Utility.fromJson(data);
  return utility;
}

// Post utility entry
Future<void> postUtility(
    double lat, double lon, String description, String filePath) async {
  var uri = Uri.http(env['API_URL'], '/utility');
  var request = http.MultipartRequest('POST', uri)
    ..fields['lat'] = lat.toString()
    ..fields['lon'] = lon.toString()
    ..fields['description'] = description
    ..files.add(await http.MultipartFile.fromPath('image', filePath));

  var response = await request.send();

  if (response.statusCode != 200) {
    throw Exception('Failed to post utility');
  }
}

// Update utility entry
Future<void> updateUtility(Utility utility) async {
  var id = utility.id;
  http.Response response = await http.post(
    Uri.http(env['API_URL'], '/utility/$id'),
    body: {
      'description': utility.description,
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to edit utility');
  }
}

// Rate utility
Future<void> rateUtility(Utility utility, int rating) async {
  var id = utility.id;
  http.Response response = await http.post(
    Uri.http(env['API_URL'], '/utility/$id/rate'),
    body: {
      'rating': utility.description,
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to rate utility');
  }
}
