import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:utility_finder/models/utility.dart';
import 'package:utility_finder/services/api.dart';
import 'package:utility_finder/services/marker.dart';

// Home screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _lat = 38.893452;
  double _lon = -77.014709;
  final double _radius = 1;

  GoogleMapController mapController;
  final LatLng _center = const LatLng(38.893452, -77.014709);
  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    fetchUtilities(_lat, _lon, _radius).then((res) async {
      Map<String, Marker> markers = {};
      for (final utility in res) {
        final marker = Marker(
          markerId: MarkerId(utility.id),
          position: LatLng(utility.lat, utility.lon),
          infoWindow: InfoWindow(
              title: utility.rating.toString(),
              snippet: utility.description,
              onTap: () {
                Navigator.pushNamed(context, '/details', arguments: utility);
              }),
          icon: await getIconFromNetwork(utility.imageURL),
        );
        markers[utility.id] = marker;
      }

      setState(() {
        _markers.clear();
        _markers.addAll(markers);
      });
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers.values.toSet(),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Center(
              child: ElevatedButton(
                child: Text('+ Add'),
                onPressed: () {
                  Navigator.pushNamed(context, '/submit');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
