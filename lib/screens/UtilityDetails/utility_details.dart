import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utility_finder/models/utility.dart';
import 'package:utility_finder/services/api.dart';

class UtilityDetailsScreen extends StatefulWidget {
  final SharedPreferences prefs;

  UtilityDetailsScreen({Key key, this.prefs}) : super(key: key);

  @override
  _UtilityDetailsScreen createState() => _UtilityDetailsScreen();
}

class _UtilityDetailsScreen extends State<UtilityDetailsScreen> {
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = widget.prefs;
  }

  AlertDialog getSuccessDialog(BuildContext context) {
    return AlertDialog(
      content: Text("Thank you for your feedback!"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  AlertDialog getErrorDialog(BuildContext context) {
    return AlertDialog(
      content: Text("An error has occured."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Utility utility = ModalRoute.of(context).settings.arguments;
    final String id = utility.id;
    final int rating = _prefs.getInt('$id-rating') ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: utility.imageURL,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
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
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RatingBar.builder(
                    initialRating: rating.toDouble(),
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (v) async {
                      final int rating = v.toInt();
                      var alertDialog;
                      try {
                        // Send rating
                        await rateUtility(utility, rating);
                        // Cache rating
                        final String id = utility.id;
                        await _prefs.setInt('$id-rating', rating);
                        alertDialog = getSuccessDialog(context);
                      } catch (e) {
                        alertDialog = getErrorDialog(context);
                      }

                      showGeneralDialog(
                        barrierLabel: 'Label',
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: Duration(milliseconds: 300),
                        context: context,
                        pageBuilder: (context, anim1, anim2) {
                          return alertDialog;
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(utility.description),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
