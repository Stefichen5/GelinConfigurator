import 'package:flutter/material.dart';
import 'package:gelin_configurator/configurator.dart';
import './newproject.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewProject()));
            },
            child: Text('New project')),
        FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Configurator(
                          '/home/stefan/Documents/gelin/HelloWorld')));
            },
            child: Text('Open project'))
      ],
    );
  }
}
