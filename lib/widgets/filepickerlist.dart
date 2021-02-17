import 'package:flutter/material.dart';

class FilePickerList extends StatefulWidget {
  final String name;
  final List<String> _preSelected;
  final List<String> content;
  final Function callback;

  FilePickerList(
    this.name,
    this.content,
    this._preSelected,
    this.callback,
  );

  @override
  _FilePickerListState createState() => _FilePickerListState();
}

class _FilePickerListState extends State<FilePickerList> {
  List<String> availableFiles;
  final _saved = Set<String>();
  String _searchTerm = '';
  bool _initFinished = false;

  List<String> _getVisible(String filterText) {
    List<String> visible = [];
    visible = widget.content.where((element) {
      return element.contains(filterText);
    }).toList();
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    availableFiles = widget.content;

    //add already selected packages to list
    if (!_initFinished &&
        widget._preSelected.length > 0 &&
        widget.content.length > 0) {
      for (final elem in widget._preSelected) {
        if (!_saved.contains(elem)) {
          _saved.add(elem);
        }
      }
      _initFinished = true;
    }

    return Card(
      child: ExpansionTile(title: Text(widget.name), children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.search),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Search'),
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        ...(_getVisible(_searchTerm)).map((elem) {
          final alreadySaved =
              widget._preSelected.contains(elem) || _saved.contains(elem);
          return ListTile(
            title: Text(elem),
            trailing: Icon(
              alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
              color: alreadySaved ? Theme.of(context).accentColor : null,
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
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
