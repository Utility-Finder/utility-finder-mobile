import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:utility_finder/models/utility.dart';
import 'package:utility_finder/services/api.dart';

// Home screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _lat = 38.893452;
  double _lon = -77.014709;
  final double _radius = 1;
  List<Utility> _utilities = [];

  GoogleMapController mapController;
  final LatLng _center = const LatLng(38.893452, -77.014709);
  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    fetchUtilities(_lat, _lon, _radius).then((res) {
      setState(() {
        _utilities = res;
        _markers.clear();
        for (final utility in res) {
          final marker = Marker(
            markerId: MarkerId(utility.id),
            position: LatLng(utility.lat, utility.lon),
            infoWindow: InfoWindow(
              title: utility.description,
              snippet: utility.description,
            ),
          );
          _markers[utility.id] = marker;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
