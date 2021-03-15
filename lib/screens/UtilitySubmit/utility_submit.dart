import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utility_finder/services/api.dart';

class UtilitySubmitScreen extends StatefulWidget {
  @override
  _UtilitySubmitScreen createState() => _UtilitySubmitScreen();
}

class _UtilitySubmitScreen extends State<UtilitySubmitScreen> {
  File _image;
  final picker = ImagePicker();
  String _description = '';

  // Gets image via camera
  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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

  Widget renderNoImage(BuildContext context) {
    return GestureDetector(
      onTap: getImage,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 80,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Add a Photo',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderHasImage(BuildContext context) {
    return ListView(
      children: [
        Stack(
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
              child: Image.file(_image),
            ),
            Positioned(
                right: 10,
                top: 10,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: getImage,
                      child: Icon(Icons.add_a_photo),
                    ),
                  ],
                )),
          ],
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
          child: Expanded(
            child: ElevatedButton(
              onPressed: () async {
                var alertDialog;
                try {
                  // TODO: find user gps coords
                  await postUtility(0, 0, _description, _image.path);
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit a Utility"),
      ),
      body: _image == null ? renderNoImage(context) : renderHasImage(context),
    );
  }
}
