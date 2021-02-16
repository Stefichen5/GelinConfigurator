import 'package:flutter/material.dart';
import 'package:gelin_configurator/screens/projectpicker.dart';
import 'newproject.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewProject()));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.create,
                    size: 50,
                  ),
                  Text(
                    'New project',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProjectPicker()));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 50,
                  ),
                  Text(
                    'Open project',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )),
        ),
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            showLicensePage(context: context);
          },
          tooltip: 'License information',
        ),
      ],
    );
  }
}
