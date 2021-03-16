import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utility_finder/services/api.dart';

class UtilitySubmitScreen extends StatefulWidget {
  @override
  _UtilitySubmitScreen createState() => _UtilitySubmitScreen();
}

class _UtilitySubmitScreen extends State<UtilitySubmitScreen> {
  String _description = '';

  AlertDialog getSuccessDialog(BuildContext context) {
    return AlertDialog(
      content: Text("Successfully submitted!"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  AlertDialog getErrorDialog(BuildContext context) {
    return AlertDialog(
      content: Text("Could not submit utility."),
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
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final File image = args['image'];
    final Position currentPosition = args['position'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Submit a Utility"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
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
            child: Image.file(
              image,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async {
                var alertDialog;
                try {
                  await postUtility(
                    currentPosition.latitude,
                    currentPosition.longitude,
                    _description,
                    image.path,
                  );
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
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
