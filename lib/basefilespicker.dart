import 'package:flutter/material.dart';
import 'package:gelin_configurator/classes/configs.dart';
import 'package:gelin_configurator/genericdropdown.dart';

class BaseFilesPicker extends StatefulWidget {
  final List<Map<String, Object>> _files;

  BaseFilesPicker(this._files);

  @override
  _BaseFilesPickerState createState() => _BaseFilesPickerState();
}

class _BaseFilesPickerState extends State<BaseFilesPicker> {
  final _baseFilesController = TextEditingController();
  List<Map<String, Object>> _filteredFiles = [];

  List<Map<String, Object>> getFiltered(String filter) {
    List<Map<String, Object>> result = [];
    result = widget._files.where((element) {
      return element['path'].toString().contains(filter);
    }).toList();

    List<String> addedFiles = Configs.baseFiles.split(' ');

    //remove elements already in list
    result.removeWhere((element) {
      return addedFiles.contains(element['path']);
    });

    //sort
    result.sort((elemA, elemB) {
      var r = elemA['path'].toString().compareTo(elemB['path'].toString());
      if (r != 0) {
        return r;
      }
      return elemA['path'].toString().compareTo(elemB['path'].toString());
    });

    return result;
  }

  void _addFile(String file) {
    setState(() {
      Configs.baseFiles += ' $file';
      _filteredFiles = getFiltered(_baseFilesController.text);
    });
  }

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
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(labelText: 'Add file'),
              onChanged: (value) {
                setState(() {
                  _filteredFiles = getFiltered(value);
                });
              },
              controller: _baseFilesController,
            ),
          ),
          GenericDropdown(_filteredFiles, _addFile, 10),
        ],
      ),
    );
  }
}
