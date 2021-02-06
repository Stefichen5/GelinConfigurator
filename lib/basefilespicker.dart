import 'package:flutter/material.dart';
import 'package:gelin_configurator/classes/configs.dart';

class BaseFilesPicker extends StatefulWidget {
  final List<Map<String, Object>> _files;

  BaseFilesPicker(this._files);

  @override
  _BaseFilesPickerState createState() => _BaseFilesPickerState();
}

class _BaseFilesPickerState extends State<BaseFilesPicker> {
  final _baseFilesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget._files == null) {
      return Container();
    }
    return Card(
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text('Base files'),
        children: [
          ...Configs.baseFiles.split(' ').map((elem) {
            if (elem == '') {
              return Container();
            }
            return ListTile(
              title: Text(elem),
              trailing: IconButton(
                icon: Icon(Icons.highlight_remove),
                onPressed: () {
                  setState(() {
                    Configs.baseFiles = Configs.baseFiles
                        .replaceFirst(elem, '')
                        .replaceAll('  ', ' ');
                  });
                },
              ),
            );
          }),
          Divider(),
          TextField(
            decoration: InputDecoration(labelText: 'Add file'),
            onChanged: (value) {
              //TODO: Filter list of availabe files and show
            },
            controller: _baseFilesController,
          )
        ],
      ),
    );
  }
}
