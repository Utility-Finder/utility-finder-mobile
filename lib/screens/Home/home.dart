import 'package:flutter/material.dart';
import 'package:utility_finder/models/utility.dart';
import 'package:utility_finder/services/api.dart';

// Home screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _lat = 0;
  double _lon = 0;
  final double _radius = 1;
  List<Utility> _utilities = [];

  @override
  void initState() {
    super.initState();
    fetchUtilities(_lat, _lon, _radius).then((res) {
      print(res);
      setState(() {
        _utilities = res;
      });
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: _utilities.length,
        itemBuilder: (context, index) {
          return Text(_utilities[index].description);
        },
      ),
    );
  }
}
