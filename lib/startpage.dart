import 'package:flutter/material.dart';
import 'package:gelin_configurator/projectpicker.dart';
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
                      builder: (context) =>
                          ProjectPicker())); //Configurator('/home/stefan/Documents/aaaaaaa')));
            },
            child: Text('Open project'))
      ],
    );
  }
}
