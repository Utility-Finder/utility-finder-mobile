import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:utility_finder/screens/Home/home.dart';
import 'package:utility_finder/screens/UtilityDetails/utility_details.dart';
import 'package:utility_finder/screens/UtilitySubmit/utility_submit.dart';

Future main() async {
  await DotEnv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/submit':
            return CupertinoPageRoute(
                builder: (context) => UtilitySubmitScreen(),
                settings: settings);
          case '/details':
            return CupertinoPageRoute(
                builder: (context) => UtilityDetailsScreen(prefs: prefs),
                settings: settings);
          default:
            return CupertinoPageRoute(
                builder: (context) => HomeScreen(), settings: settings);
        }
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text("Utility Finder"),
        ),
        body: HomeScreen(),
      ),
    ),
  );
}
