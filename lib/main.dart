import 'package:flutter/material.dart';

import 'package:partykviz/Pages/pickName.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => PickName(title: 'Vítá tě Párty kvíz!'),
          //'/second': (context) => SecondScreen(),
        });
  }
}
