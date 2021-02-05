import 'package:flutter/material.dart';
import 'dart:io';

class VersionPicker extends StatefulWidget {
  final Function callback;
  final String initial;

  VersionPicker(this.callback, this.initial);

  @override
  _VersionPickerState createState() => _VersionPickerState();
}

class _VersionPickerState extends State<VersionPicker> {
  String dropdownValue;

  List<String> get getAvailableVersions {
    List<String> versions = [widget.initial];

    var dir = new Directory("/opt/");
    List contents = dir.listSync();

    for (var entry in contents) {
      if (entry is Directory) {
        if (entry.path.contains("gelin2-") &&
            (!entry.path.contains("common"))) {
          final String version = entry.path
              .substring(entry.path.lastIndexOf("/") + 1, entry.path.length);
          if (!versions.contains(version)) versions.add(version);
        }
      }
    }

    return versions;
  }

  @override
  Widget build(BuildContext context) {
    if (dropdownValue == null) {
      dropdownValue = widget.initial;
    }
    return DropdownButton<String>(
      value: dropdownValue,
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
