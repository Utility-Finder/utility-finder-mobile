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

  // Submit utility
  Future<void> submitUtility() async {
    // TODO: get users current position
    await postUtility(0, 0, _description, _image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit a Utility"),
      ),
      body: Column(
        children: [
          Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(_image),
          ),
          ElevatedButton(
            onPressed: getImage,
            child: Icon(Icons.add_a_photo),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: submitUtility,
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
