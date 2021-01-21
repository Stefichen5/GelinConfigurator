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
  String name = "";
  String path = "";
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
        name != "" &&
        path != "") {
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
                  decoration: InputDecoration(hintText: 'Project name'),
                  onChanged: (text) {
                    name = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Project path'),
                  onChanged: (text) {
                    path = text;
                  },
                ),
                VersionPicker(setGelinVersion),
                TemplatePicker(gelinVersion, setTemplate),
                FloatingActionButton(
                  onPressed: isButtonEnabled()
                      ? () {
                          _createNewProject(name, path, gelinVersion, template);
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
