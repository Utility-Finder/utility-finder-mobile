import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utility_finder/models/utility.dart';
import 'package:utility_finder/services/api.dart';
import 'package:utility_finder/services/marker.dart';
import 'package:utility_finder/services/location.dart';

// Home screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _radius = 1;

  GoogleMapController _mapController;
  final LatLng _center = const LatLng(38.893452, -77.014709);
  final Map<String, Marker> _markers = {};
  Position _currentPosition;
  bool _isLocationEnabled = false;
  bool _isMarkersInit = false;

  final Map<int, Color> _markerColors = {
    0: Colors.cyan[200],
    1: Colors.orange[600],
    2: Colors.green[700],
  };

  final picker = ImagePicker();

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  Future<Map<String, Marker>> getMarkers(Position pos) async {
    List<Utility> res = await fetchUtilities(
      pos.latitude,
      pos.longitude,
      _radius,
    );
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
        icon: await createIconFromNetwork(
          utility.imageURL,
          _markerColors[utility.type] ?? Colors.black,
        ),
      );
      markers[utility.id] = marker;
    }
    return markers;
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition().then((pos) {
      setState(() {
        _currentPosition = pos;
        _isLocationEnabled = true;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  Widget renderLocationEnabled(BuildContext context) {
    // Init markers
    if (!_isMarkersInit) {
      getMarkers(_currentPosition).then((markers) {
        setState(() {
          _markers.clear();
          _markers.addAll(markers);
        });
      }).catchError((e) {
        print(e.toString());
      });
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          myLocationEnabled: _isLocationEnabled,
          myLocationButtonEnabled: true,
          markers: _markers.values.toSet(),
        ),
        Positioned(
          bottom: 30,
          left: 5,
          child: Center(
            child: ElevatedButton(
              child: Text('+ Add'),
              onPressed: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  var image = File(pickedFile.path);
                  Navigator.pushNamed(context, '/submit', arguments: image);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget renderLocationNotEnabled(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          Position pos = await getCurrentPosition();
          setState(() {
            _currentPosition = pos;
            _isLocationEnabled = true;
          });
        } catch (e) {
          print(e.toString());
        }
      },
      child: Text('Enable location services'),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Utility Finder"),
      ),
      body: _isLocationEnabled
          ? renderLocationEnabled(context)
          : renderLocationNotEnabled(context),
    );
  }
}
