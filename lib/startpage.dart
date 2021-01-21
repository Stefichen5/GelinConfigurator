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
                      builder: (context) =>
                          Configurator('/opt/gelin2-20.10-imx6ul/packages')));
            },
            child: Text('Open project'))
      ],
    );
  }
}
