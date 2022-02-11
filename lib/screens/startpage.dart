import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'newproject.dart';
import 'configurator.dart';

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
              onPressed: () async {
                String selectedDirectory =
                    await FilePicker.platform.getDirectoryPath();
                print(selectedDirectory);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Configurator(selectedDirectory)));
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
