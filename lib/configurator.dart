import 'package:flutter/material.dart';
import 'package:gelin_configurator/advancedsettings.dart';
import 'package:gelin_configurator/addremovelist.dart';
import 'package:gelin_configurator/versionpicker.dart';
import './filepicker.dart';
import 'dart:io';

class Configurator extends StatefulWidget {
  final String path;

  Configurator(this.path);

  @override
  _ConfiguratorState createState() => _ConfiguratorState();
}

class _ConfiguratorState extends State<Configurator> {
  String gelinVersion = "gelin2-20.10-imx6ul";
  List<String> packages = [];
  List<String> _preSelectedPackages = [];
  List<String> _availablePackages = [];
  List<String> _subprojects = [];
  List<String> _removed = [];

  bool _advancedMode = false;
  String _advancedModeButtonString = 'Show advanced settings';

  final _projectVersion = TextEditingController();
  final _description = TextEditingController();
  final _projectName = TextEditingController();

  void addSubproject(String subproject) {
    setState(() {
      _subprojects.add(subproject);
    });
  }

  void removeSubproject(String subproject) {
    setState(() {
      _subprojects.remove(subproject);
    });
  }

  void addToRemovedList(String remove) {
    setState(() {
      _removed.add(remove);
    });
  }

  void removeFromRemovedList(String remove) {
    setState(() {
      _removed.remove(remove);
    });
  }

  void setVersion(String v) {
    setState(() {
      gelinVersion = v;
    });
  }

  void setPackages(List<String> p) {
    packages = p;
  }

  Future<File> _buildFile(String path) async {
    return File(path);
  }

  Future<void> parseBuildShFile() async {
    String description = '';
    String version = '';
    String name = '';

    try {
      var buildFile = await _buildFile('${widget.path}/build.sh');

      var lines = await buildFile.readAsLines();

      for (final line in lines) {
        if (line.contains('PROJECT_NAME=')) {
          name = line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
        } else if (line.contains('PROJECT_VERSION=')) {
          version =
              line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
        } else if (line.contains('PROJECT_BUILD_VERSION=')) {
          //todo: not sure if this works. need to test later
          gelinVersion =
              line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
        } else if (line.contains('PROJECT_VERSION_STRING=')) {
          description =
              line.substring(line.indexOf('} ') + 2, line.lastIndexOf('"'));
        }
        //todo: parse the rest
      }

      setState(() {
        _projectVersion.text = version;
        _description.text = description;
        _projectName.text = name;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> parseProjectConfFile() async {
    try {
      var projectConf = await _buildFile('${widget.path}/gelin_project.conf');
      var lines = await projectConf.readAsLines();
      List<String> subprojects = [];
      List<String> selectedPackages = [];
      List<String> removedFiles = [];

      for (final line in lines) {
        if (line.contains('BASE_PACKAGES=')) {
          String packages =
              line.substring(line.indexOf('="') + 2, line.lastIndexOf('"'));
          selectedPackages = packages.split(' ');
        } else if (line.contains('SUBPROJECTS="')) {
          String tmp = line.substring(line.indexOf('"') + 1, line.length - 1);
          subprojects = tmp.split(' ');
        } else if (line.contains('BASE_REMOVE="')) {
          String tmp = line.substring(line.indexOf('"') + 1, line.length - 1);
          removedFiles = tmp.split(' ');
        }
      }

      //need initial list of packages to be populated
      //otherwise it is empty and might get written
      //to file as empty
      packages = selectedPackages;

      setState(() {
        _preSelectedPackages = selectedPackages;
        _subprojects = subprojects;
        _removed = removedFiles;
      });
    } catch (e) {
      return;
    }
  }

  Future<List<String>> _getPackages(String path) async {
    List<String> result = [];

    try {
      var dir = new Directory(path);
      List contents = dir.listSync();

      for (var entry in contents) {
        if (entry is Directory) {
          result.add(entry.path
              .substring(entry.path.lastIndexOf("/") + 1, entry.path.length));
        }
      }
    } on FileSystemException {}

    return result;
  }

  Future<bool> _saveChanges() async {
    print('Save');
    try {
      //---------------------------------------------
      //Save build.sh file
      //---------------------------------------------
      var buildShFile = await _buildFile('${widget.path}/build.sh');
      List<String> fileContent = buildShFile.readAsLinesSync();

      for (var i = 0; i < fileContent.length; i++) {
        var line = fileContent[i];

        if (line.contains('PROJECT_NAME="')) {
          fileContent[i] = 'PROJECT_NAME="${_projectName.text}"';
        } else if (line.contains('PROJECT_VERSION="')) {
          fileContent[i] = 'PROJECT_VERSION="${_projectVersion.text}"';
        } else if (line.contains('PROJECT_BUILD_VERSION="')) {
          fileContent[i] = 'PROJECT_BUILD_VERSION="$gelinVersion"';
        } else if (line.contains('PROJECT_VERSION_STRING="')) {
          fileContent[i] =
              'PROJECT_VERSION_STRING="\${PROJECT_NAME}-\${PROJECT_VERSION} ${_description.text}"';
        }
      }
      buildShFile.writeAsStringSync(fileContent.join('\n'));

      //---------------------------------------------
      //Save gelin_project.conf file
      //---------------------------------------------
      var projectConfFile =
          await _buildFile('${widget.path}/gelin_project.conf');
      fileContent = projectConfFile.readAsLinesSync();

      for (var i = 0; i < fileContent.length; i++) {
        var line = fileContent[i];

        if (line.contains('BASE_PACKAGES="')) {
          var packagesSingleString = packages.join(' ');
          fileContent[i] = 'BASE_PACKAGES="$packagesSingleString"';
        } else if (line.contains('SUBPROJECTS="')) {
          var subprojectsSingleString = _subprojects.join(' ');
          fileContent[i] = 'SUBPROJECTS="$subprojectsSingleString"';
        } else if (line.contains('BASE_REMOVE="')) {
          var baseRemoveSingleString = _removed.join(' ');
          fileContent[i] = 'BASE_REMOVE="$baseRemoveSingleString"';
        }
      }

      projectConfFile.writeAsStringSync(fileContent.join('\n'));
    } catch (e) {
      return false;
    }

    return true;
  }

  void toggleAdvancedMode() {
    setState(() {
      _advancedMode = !_advancedMode;
      _advancedMode
          ? _advancedModeButtonString = 'Hide advanced settings'
          : _advancedModeButtonString = 'Show advanced settings';
    });
  }

  @override
  void initState() {
    super.initState();
    _getPackages('/opt/$gelinVersion/packages').then((value) {
      setState(() {
        _availablePackages = value;
      });
    });
    parseBuildShFile();
    parseProjectConfFile();
    print('init done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure project'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveChanges();
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _projectName,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Version'),
                controller: _projectVersion,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: _description,
              ),
              VersionPicker(setVersion, gelinVersion),
              Container(
                  child: FilePickerList('Packages', _availablePackages,
                      _preSelectedPackages, setPackages)),
              AddRemoveList(
                  _subprojects, 'Subprojects', removeSubproject, addSubproject),
              AddRemoveList(_removed, 'Removed files', removeFromRemovedList,
                  addToRemovedList),
              FlatButton(
                  onPressed: toggleAdvancedMode,
                  child: Text(_advancedModeButtonString)),
              _advancedMode ? AdvancedSettings() : Container(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _saveChanges,
      ),
    );
  }
}
