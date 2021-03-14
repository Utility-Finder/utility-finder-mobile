import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:utility_finder/screens/Home/home.dart';
import 'package:utility_finder/screens/UtilityDetails/utility_details.dart';
import 'package:utility_finder/screens/UtilitySubmit/utility_submit.dart';

Future main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                builder: (context) => UtilityDetailsScreen(),
                settings: settings);
          case '/':
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
    );
  }
}
