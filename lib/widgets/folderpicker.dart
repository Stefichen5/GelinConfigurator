import 'package:flutter/material.dart';

class FolderPicker extends StatelessWidget {
  final List<String> _options;
  final Function _callback;

  FolderPicker(this._options, this._callback);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.arrow_upward),
          title: (Text('(up)')),
          onTap: () => _callback('..'),
        ),
        ..._options.map((elem) {
          return ListTile(
            leading: Icon(Icons.folder),
            title: Text(elem),
            onTap: () => _callback(elem),
          );
        })
      ],
    );
  }
}
