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
  String gelin_version = "gelin2-20.10-imx6ul";
  List<String> packages = [];

  final _projectVersion = TextEditingController();
  final _description = TextEditingController();

  void setVersion(String v) {
    setState(() {
      gelin_version = v;
    });
  }

  void set_packages(List<String> p) {
    packages = p;
  }

  void parseBuildShFile() {
    var buildFile = new File(widget.path + 'build.sh');
  }

  List<String> _getPackages(String path) {
    List<String> result = [];

    try {
      var dir = new Directory(path);
      List contents = dir.listSync();

      for (var entry in contents) {
        if (entry is Directory) {
          result.add(entry.path
              .substring(entry.path.lastIndexOf("/") + 1, entry.path.length));
        }
      }
    } on FileSystemException {}

    return result;
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
                  decoration: InputDecoration(labelText: 'Version'),
                  controller: _projectVersion,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  controller: _description,
                ),
                VersionPicker(setVersion, gelin_version),
                Container(
                    child: FilePickerList(
                        'Packages',
                        _getPackages('/opt/$gelin_version/packages'),
                        set_packages))
              ],
            ),
          ),
        ));
  }
}
