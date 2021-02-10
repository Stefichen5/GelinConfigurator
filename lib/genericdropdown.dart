import 'package:flutter/material.dart';

class GenericDropdown extends StatefulWidget {
  final List<Map<String, Object>> _elems;
  final Function _selectCallback;
  final int _listThreshhold;

  GenericDropdown(this._elems, this._selectCallback, this._listThreshhold);

  @override
  _GenericDropdownState createState() => _GenericDropdownState();
}

class _GenericDropdownState extends State<GenericDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget._elems.length > widget._listThreshhold
          ? Column(
              children: [
                Text(
                  '''Too many elements. Please narrow down results\n 
                  Showing only first ${widget._listThreshhold} elements''',
                  style: TextStyle(color: Colors.red),
                ),
                ...widget._elems
                    .getRange(0, widget._listThreshhold)
                    .map((elem) {
                  return ListTile(
                    title: Text(elem['path']),
                    leading: elem['isFolder']
                        ? Icon(Icons.folder)
                        : Icon(Icons.file_present),
                    onTap: () {
                      //TODO: Check if folder can be added like that
                      //or maybe needs /*
                      widget._selectCallback(elem['path']);
                    },
                  );
                })
              ],
            )
          : Column(
              children: [
                Text('Found ${widget._elems.length} elements'),
                ...widget._elems.map((elem) {
                  return ListTile(
                    title: Text(elem['path']),
                    leading: elem['isFolder']
                        ? Icon(Icons.folder)
                        : Icon(Icons.file_present),
                    onTap: () {
                      //TODO: Check if folder can be added like that
                      //or maybe needs /*
                      widget._selectCallback(elem['path']);
                    },
                  );
                })
              ],
            ),
    );
  }
}
