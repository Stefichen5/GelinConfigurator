import 'package:flutter/material.dart';
import 'package:gelin_configurator/configurator.dart';
import 'package:gelin_configurator/templatepicker.dart';
import 'package:gelin_configurator/versionpicker.dart';
import 'dart:io';

class NewProject extends StatefulWidget {
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final name = TextEditingController();
  final path = TextEditingController();
  String gelinVersion = "";
  String template = "EMPTY";

  void setGelinVersion(String v) {
    setState(() {
      gelinVersion = v;
    });
  }

  void setTemplate(String t) {
    template = t;
  }

  bool isButtonEnabled() {
    if (gelinVersion.contains("gelin2") &&
        template != "Choose a template" &&
        name.text != '' &&
        path.text != '') {
      return true;
    } else {
      return false;
    }
  }

  void _createNewProject(
      String name, String path, String gelinVersion, String template) {
    print("Name: $name");
    print("Path: $path");
    print("Gelin: $gelinVersion");
    print("Template: $template");

    Process.run('/opt/$gelinVersion/bin/gelin_project_create.sh',
            ['-p', name, '-t', template],
            workingDirectory: path)
        .then((value) {
      print(value);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Configurator(path + "/" + name)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create new project'),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Project name'),
                  controller: name,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Project path'),
                  controller: path,
                ),
                VersionPicker(setGelinVersion, 'Choose a version'),
                TemplatePicker(gelinVersion, setTemplate),
                FloatingActionButton(
                  onPressed: isButtonEnabled()
                      ? () {
                          _createNewProject(
                            name.text,
                            path.text,
                            gelinVersion,
                            template,
                          );
                        }
                      : null,
                  child: Icon(Icons.check),
                )
              ],
            ),
          ),
        ));
  }
}
