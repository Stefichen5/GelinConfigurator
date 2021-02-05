import 'package:flutter/material.dart';
import 'package:gelin_configurator/advancedsettings.dart';
import 'package:gelin_configurator/addremovelist.dart';
import 'package:gelin_configurator/classes/configs.dart';
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
  Configs projectConfigs;
  List<String> _availablePackages = [];

  bool _advancedMode = false;
  String _advancedModeButtonString = 'Show advanced settings';

  final _projectVersion = TextEditingController();
  final _description = TextEditingController();
  final _projectName = TextEditingController();

  void _configParseDoneCallback() {
    _getPackages('/opt/${projectConfigs.projectBuildVersion}/packages')
        .then((value) {
      setState(() {
        _availablePackages = value;
      });
    });

    setState(() {
      _projectVersion.text = projectConfigs.projectVersion;
      _description.text = projectConfigs.projectVersionString;
      _projectName.text = projectConfigs.projectName;
    });
  }

  void addSubproject(String subproject) {
    setState(() {
      projectConfigs.subprojects += ' $subproject';
    });
  }

  void removeSubproject(String subproject) {
    setState(() {
      projectConfigs.subprojects =
          projectConfigs.subprojects.replaceFirst(subproject, '');
    });
  }

  void addToRemovedList(String remove) {
    setState(() {
      projectConfigs.baseRemove += ' $remove';
    });
  }

  void removeFromRemovedList(String remove) {
    setState(() {
      projectConfigs.baseRemove =
          projectConfigs.baseRemove.replaceFirst(remove, '');
    });
  }

  void setVersion(String v) {
    setState(() {
      projectConfigs.projectBuildVersion = v;
    });
  }

  void setPackages(List<String> p) {
    projectConfigs.basePackages = p.join(' ');
  }

  Future<File> _buildFile(String path) async {
    return File(path);
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
          fileContent[i] =
              'PROJECT_BUILD_VERSION="${projectConfigs.projectBuildVersion}"';
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
          fileContent[i] = 'BASE_PACKAGES="${projectConfigs.basePackages}"';
        } else if (line.contains('SUBPROJECTS="')) {
          fileContent[i] = 'SUBPROJECTS="${projectConfigs.subprojects}"';
        } else if (line.contains('BASE_REMOVE="')) {
          fileContent[i] = 'BASE_REMOVE="${projectConfigs.baseRemove}"';
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
    projectConfigs = Configs(widget.path, _configParseDoneCallback);
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
              projectConfigs.projectBuildVersion.length > 0
                  ? VersionPicker(
                      setVersion, projectConfigs.projectBuildVersion)
                  : Container(),
              Container(
                  child: FilePickerList('Packages', _availablePackages,
                      projectConfigs.basePackages.split(' '), setPackages)),
              AddRemoveList(projectConfigs.subprojects.split(' '),
                  'Subprojects', removeSubproject, addSubproject),
              AddRemoveList(projectConfigs.baseRemove.split(' '),
                  'Removed files', removeFromRemovedList, addToRemovedList),
              FlatButton(
                  onPressed: toggleAdvancedMode,
                  child: Text(_advancedModeButtonString)),
              _advancedMode ? AdvancedSettings(projectConfigs) : Container(),
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
