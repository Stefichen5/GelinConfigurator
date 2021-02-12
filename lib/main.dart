import 'package:flutter/material.dart';
import 'package:gelin_configurator/screens/startpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gelin configurator'),
        ),
        body: Center(child: StartPage()),
      ),
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green,
      ),
    );
  }
}
