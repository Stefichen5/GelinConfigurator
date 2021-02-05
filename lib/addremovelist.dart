import 'package:flutter/material.dart';

class AddRemoveList extends StatelessWidget {
  final List<String> _subprojects;
  final String _title;
  final Function _removeCallback;
  final Function _addCallback;

  final subprojectPathController = TextEditingController();

  AddRemoveList(
      this._subprojects, this._title, this._removeCallback, this._addCallback);

  @override
  Widget build(BuildContext context) {
    //do not keep empty objects
    _subprojects.removeWhere((element) => element.length < 1);

    return Card(
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(_title),
        children: [
          ..._subprojects.map((elem) {
            return ListTile(
              title: Text(elem),
              trailing: IconButton(
                icon: Icon(Icons.highlight_remove),
                onPressed: () {
                  _removeCallback(elem);
                },
              ),
            );
          }),
          Divider(),
          ListTile(
            title: TextField(
              decoration: InputDecoration(labelText: 'Path'),
              controller: subprojectPathController,
            ),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addCallback(subprojectPathController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
