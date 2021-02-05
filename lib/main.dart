import 'package:flutter/material.dart';
import 'package:gelin_configurator/startpage.dart';

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
        primaryColor: Colors.green,
        accentColor: Colors.green,
      ),
    );
  }
}
