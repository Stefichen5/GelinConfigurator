import 'package:flutter/material.dart';

class DropdownPicker extends StatelessWidget {
  final List<String> _elems;
  final int _defaultElem;
  final Function _callback;

  DropdownPicker(this._elems, this._defaultElem, this._callback);

  @override
  Widget build(BuildContext context) {
    if (_defaultElem >= _elems.length) {
      return Container();
    }

    return DropdownButton<String>(
      value: _elems[_defaultElem],
      icon: Icon(Icons.arrow_downward),
      onChanged: (value) {
        _callback(value);
      },
      underline: Container(
        height: 2,
        color: Theme.of(context).accentColor,
      ),
      items: [
        ..._elems.map((e) {
          return DropdownMenuItem(child: Text(e), value: e);
        })
      ],
    );
  }
}
