import 'package:flutter/material.dart';

class AddRemoveListChip extends StatelessWidget {
  final List<String> _elems;
  final Function _callback;

  AddRemoveListChip(this._elems, this._callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 5,
          runSpacing: 5,
          children: [
            ..._elems.map((elem) {
              return elem.length > 1
                  ? Chip(
                      label: Text(elem),
                      onDeleted: () {
                        _callback(elem);
                      },
                    )
                  : Container();
            })
          ],
        ),
      ),
    );
  }
}
