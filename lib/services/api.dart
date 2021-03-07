import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:utility_finder/models/utility.dart';

// Fetches list of nearby utilities
Future<List<Utility>> fetchUtilities(
    double lat, double lon, double radius) async {
  var apiURL = env['API_URL'];
  http.Response response =
      await http.get(Uri.parse("$apiURL/list?lat=$lon&radius=$radius"));

  Map<String, dynamic> data = jsonDecode(response.body);
  var list = data as List;
  List<Utility> utilities = list.map((e) => Utility.fromJson(e)).toList();
  return utilities;
}
