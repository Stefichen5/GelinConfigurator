import 'package:flutter/material.dart';

class FilePickerList extends StatefulWidget {
  final String name;
  final List<String> content;
  final Function callback;

  FilePickerList(
    this.name,
    this.content,
    this.callback,
  );

  @override
  _FilePickerListState createState() => _FilePickerListState();
}

class _FilePickerListState extends State<FilePickerList> {
  List<String> availableFiles;
  final _saved = Set<String>();

  List<String> _getVisible(String filterText) {
    List<String> visible = [];
    visible = widget.content.where((element) {
      return element.contains(filterText);
    }).toList();
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    if (availableFiles == null) {
      availableFiles = widget.content;
    }

    return Card(
      child: ExpansionTile(title: Text(widget.name), children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(labelText: 'Search'),
            onChanged: (value) {
              setState(() {
                availableFiles = _getVisible(value);
              });
            },
          ),
        ),
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

                if (widget.callback != null) {
                  widget.callback(_saved.toList());
                }
              });
            },
          );
        })
      ]),
    );
  }
}
