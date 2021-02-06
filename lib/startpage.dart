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
            child: Row(
              children: [
                Icon(Icons.create),
                Text('New project'),
              ],
            )),
        FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProjectPicker()));
            },
            child: Row(
              children: [
                Icon(Icons.folder_open),
                Text('Open project'),
              ],
            ))
      ],
    );
  }
}
