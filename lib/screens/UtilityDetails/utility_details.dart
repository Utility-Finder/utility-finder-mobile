import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(children: [
                    Text(
                      utility.rating.toString(),
                      style: TextStyle(fontSize: 50),
                    ),
                    Text(
                      'out of 5',
                      style: TextStyle(fontSize: 25),
                    ),
                  ]),
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) async {
                    // Send rating
                    // TODO: cache rating
                    _rating = rating.toInt();
                    await rateUtility(utility, _rating);
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: Text(
                          "Thanks for your feedback!",
                          style: TextStyle(fontSize: 20),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
