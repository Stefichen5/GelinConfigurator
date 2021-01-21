import 'package:flutter/material.dart';
import 'dart:io';

class FilePickerList extends StatefulWidget {
  final String name;
  final String path;

  FilePickerList(this.name, this.path);

  @override
  _FilePickerListState createState() => _FilePickerListState();
}

class _FilePickerListState extends State<FilePickerList> {
  List<String> availableFiles = [''];
  final _saved = Set<String>();

  List<String> get getAvailableFiles {
    List<String> result = [];

    try {
      var dir = new Directory(widget.path);
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

  Widget _buildPackages(String text) {
    print(text);
    return ListTile(
      title: Text(text),
    );
  }

  Widget _listViewBuilder() {
    return ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, i) {
          print(i);
          return _buildPackages(availableFiles[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    availableFiles = getAvailableFiles;
    return Card(
      child: ExpansionTile(title: Text(widget.name), children: <Widget>[
        ...(availableFiles).map((elem) {
          final already_saved = _saved.contains(elem);
          return ListTile(
            title: Text(elem),
            trailing: Icon(
              already_saved ? Icons.check_box : Icons.check_box_outline_blank,
              color: already_saved ? Colors.green : null,
            ),
            onTap: () {
              setState(() {
                if (already_saved) {
                  _saved.remove(elem);
                } else {
                  _saved.add(elem);
                }
              });
            },
          );
        })
      ]),
    );
  }
}
