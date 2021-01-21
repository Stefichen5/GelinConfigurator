import 'package:flutter/material.dart';
import 'package:gelin_configurator/versionpicker.dart';
import './filepicker.dart';
import 'dart:io';

class Configurator extends StatefulWidget {
  final String path;

  Configurator(this.path);

  @override
  _ConfiguratorState createState() => _ConfiguratorState();
}

class _ConfiguratorState extends State<Configurator> {
  String version = "";

  void setVersion(String v) {
    setState(() {
      version = v;
    });
  }

  void parseBuildShFile() {
    var buildFile = new File(widget.path + 'build.sh');
  }

  @override
  Widget build(BuildContext context) {
    parseBuildShFile();

    return Scaffold(
        appBar: AppBar(
          title: Text('Configure'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: () => print("TODO: Save"),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Version'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Description'),
                ),
                VersionPicker(setVersion),
                Container(child: FilePickerList('Packages', widget.path))
              ],
            ),
          ),
        ));
  }
}
