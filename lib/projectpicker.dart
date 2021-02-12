import 'package:flutter/material.dart';
import 'dart:io';

import './folderpicker.dart';
import './configurator.dart';

class ProjectPicker extends StatefulWidget {
  @override
  _ProjectPickerState createState() => _ProjectPickerState();
}

class _ProjectPickerState extends State<ProjectPicker> {
  List<String> _folders = [];
  List<String> _foldersFiltered = [];
  String _currentDir = Platform.environment['HOME'];
  bool fabActive = false;
  var _searchController = TextEditingController();

  bool _isValidProject(List contents) {
    bool hasProjectConf = false;
    bool hasBuildSh = false;

    for (final elem in contents) {
      if (elem is File) {
        var fileName = elem.path
            .substring(elem.path.lastIndexOf('/') + 1, elem.path.length);

        if (fileName == 'build.sh') {
          hasBuildSh = true;
        } else if (fileName == 'gelin_project.conf') {
          hasProjectConf = true;
        }
      }
    }

    return hasBuildSh && hasProjectConf;
  }

  Future<void> createList(String path) {
    List<String> _result = [];
    String newDir = _currentDir;

    //build current path
    if (path != '') {
      if (path != '..') {
        newDir = '$_currentDir/$path';
      } else {
        newDir = _currentDir.substring(0, _currentDir.lastIndexOf('/'));
        if (newDir == '') {
          newDir = '/';
        }
      }
    }

    try {
      var dir = new Directory(newDir);
      List contents = dir.listSync();
      if (_isValidProject(contents)) {
        fabActive = true;
      } else {
        fabActive = false;
      }

      for (final elem in contents) {
        if (elem is Directory) {
          _result.add(elem.path
              .substring(elem.path.lastIndexOf('/') + 1, elem.path.length));
        }
      }
    } catch (e) {
      print('Exception');
    }

    print(path);

    _result.sort();

    setState(() {
      _searchController.text = '';
      _folders = _result;
      _foldersFiltered = _result;
      _currentDir = newDir;
    });

    return null;
  }

  @override
  void initState() {
    super.initState();
    createList('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a project'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              _currentDir,
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(labelText: 'Search'),
                onChanged: (value) {
                  setState(() {
                    _foldersFiltered = _folders
                        .where((element) => element.contains(value))
                        .toList();
                  });
                },
              ),
            ),
            FolderPicker(_foldersFiltered, createList),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            fabActive ? Theme.of(context).primaryColor : Colors.grey,
        child: Icon(Icons.arrow_forward),
        onPressed: fabActive
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Configurator(_currentDir)));
              }
            : null,
      ),
    );
  }
}
