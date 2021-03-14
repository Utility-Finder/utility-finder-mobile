import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:utility_finder/models/utility.dart';
import 'package:utility_finder/services/api.dart';

class UtilityDetailsScreen extends StatefulWidget {
  @override
  _UtilityDetailsScreen createState() => _UtilityDetailsScreen();
}

class _UtilityDetailsScreen extends State<UtilityDetailsScreen> {
  int _rating;

  @override
  Widget build(BuildContext context) {
    final Utility utility = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: utility.imageURL,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Text(utility.rating.toString()),
                Text(utility.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
