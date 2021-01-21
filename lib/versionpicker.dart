import 'package:flutter/material.dart';
import 'dart:io';

class VersionPicker extends StatefulWidget {
  final Function callback;

  VersionPicker(this.callback);

  @override
  _VersionPickerState createState() => _VersionPickerState();
}

class _VersionPickerState extends State<VersionPicker> {
  String dropdownValue = "Choose a version";

  List<String> get getAvailableVersions {
    List<String> versions = ['Choose a version'];

    var dir = new Directory("/opt/");
    List contents = dir.listSync();

    for (var entry in contents) {
      if (entry is Directory) {
        if (entry.path.contains("gelin2-") &&
            (!entry.path.contains("common"))) {
          versions.add(entry.path
              .substring(entry.path.lastIndexOf("/") + 1, entry.path.length));
        }
      }
    }

    return versions;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        widget.callback(newValue);
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: getAvailableVersions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
