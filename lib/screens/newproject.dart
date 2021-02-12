import 'package:flutter/material.dart';
import 'package:gelin_configurator/screens/configurator.dart';
import 'package:gelin_configurator/widgets/templatepicker.dart';
import 'package:gelin_configurator/widgets/versionpicker.dart';
import 'dart:io';

class NewProject extends StatefulWidget {
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final _name = TextEditingController();
  final _path = TextEditingController();
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
        _name.text != '' &&
        _path.text != '') {
      return true;
    } else {
      return false;
    }
  }

  void _createNewProject(
      String _name, String _path, String gelinVersion, String template) {
    print("_name: $_name");
    print("_path: $_path");
    print("Gelin: $gelinVersion");
    print("Template: $template");

    Process.run('/opt/$gelinVersion/bin/gelin_project_create.sh',
            ['-p', _name.replaceAll(' ', ''), '-t', template],
            workingDirectory: _path)
        .then((value) {
      print(value);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Configurator(_path + "/" + _name)));
    });
  }

  @override
  void initState() {
    super.initState();
    _path.text = Platform.environment['HOME'];
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
                controller: _name,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Project path'),
                controller: _path,
              ),
              VersionPicker(setGelinVersion, 'Choose a version'),
              TemplatePicker(gelinVersion, setTemplate),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isButtonEnabled()
            ? () {
                _createNewProject(
                  _name.text,
                  _path.text,
                  gelinVersion,
                  template,
                );
              }
            : null,
        child: Icon(Icons.check),
      ),
    );
  }
}
