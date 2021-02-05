import 'package:flutter/material.dart';
import 'dart:io';

class TemplatePicker extends StatefulWidget {
  final String gelinVersion;
  final Function callback;

  TemplatePicker(this.gelinVersion, this.callback);

  @override
  _TemplatePickerState createState() => _TemplatePickerState();
}

class _TemplatePickerState extends State<TemplatePicker> {
  String _dropdownValue = "Choose a template";

  List<String> get getAvailableTemplates {
    List<String> result = ['Choose a template'];

    try {
      String path = "/opt/" + widget.gelinVersion + "/templates";

      var dir = new Directory(path);
      List contents = dir.listSync();

      for (var entry in contents) {
        if (entry is Directory) {
          result.add(entry.path
              .substring(entry.path.lastIndexOf("/") + 1, entry.path.length));
        }
      }
    } on FileSystemException {
      print("eyyyy");
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Theme.of(context).accentColor,
      ),
      onChanged: (String newValue) {
        widget.callback(newValue);
        setState(() {
          _dropdownValue = newValue;
        });
      },
      items:
          getAvailableTemplates.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
