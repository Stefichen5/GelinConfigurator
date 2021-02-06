import 'package:flutter/material.dart';
import 'package:gelin_configurator/advancedsettings.dart';
import 'package:gelin_configurator/addremovelist.dart';
import 'package:gelin_configurator/classes/configs.dart';
import 'package:gelin_configurator/classes/updatecreation.dart';
import 'package:gelin_configurator/dropdownpicker.dart';
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
  List<String> _availablePackages = [];

  var _chosenUpdateId = 0;
  bool _advancedMode = false;
  String _advancedModeButtonString = 'Show advanced settings';

  final _projectVersion = TextEditingController();
  final _description = TextEditingController();
  final _projectName = TextEditingController();

  void _updateImagePickerCallback(String value) {
    var _newID = UpdateCreation.availableUpdateImageTypes.indexOf(value);
    if (value == 'Don\'t build update image') {
      value = '';
    }

    setState(() {
      _chosenUpdateId = _newID;
      Configs.projectUpdateRootfsType = value;
    });
  }

  void _configParseDoneCallback() {
    _getPackages('/opt/${Configs.projectBuildVersion}/packages').then((value) {
      setState(() {
        _availablePackages = value;
      });
    });

    setState(() {
      _projectVersion.text = Configs.projectVersion;
      _description.text = Configs.projectVersionString;
      _projectName.text = Configs.projectName;
    });
  }

  void addSubproject(String subproject) {
    setState(() {
      Configs.subprojects += ' $subproject';
    });
  }

  void removeSubproject(String subproject) {
    setState(() {
      Configs.subprojects = Configs.subprojects.replaceFirst(subproject, '');
    });
  }

  void addToRemovedList(String remove) {
    setState(() {
      Configs.baseRemove += ' $remove';
    });
  }

  void removeFromRemovedList(String remove) {
    setState(() {
      Configs.baseRemove = Configs.baseRemove.replaceFirst(remove, '');
    });
  }

  void setVersion(String v) {
    setState(() {
      Configs.projectBuildVersion = v;
    });
  }

  void setPackages(List<String> p) {
    Configs.basePackages = p.join(' ');
  }

  String getYesNoFromBool(bool val) {
    return val ? 'yes' : 'no';
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
              'PROJECT_BUILD_VERSION="${Configs.projectBuildVersion}"';
        } else if (line.contains('PROJECT_VERSION_STRING="')) {
          fileContent[i] =
              'PROJECT_VERSION_STRING="\${PROJECT_NAME}-\${PROJECT_VERSION} ${_description.text}"';
        } else if (line.contains('PROJECT_UPDATE_ROOTFS_TYPE="')) {
          fileContent[i] =
              'PROJECT_UPDATE_ROOTFS_TYPE="${Configs.projectUpdateRootfsType}"';
        } else if (line.contains('PROJECT_UPDATE_ARGS="')) {
          fileContent[i] = 'PROJECT_UPDATE_ARGS="${Configs.projectUpdateArgs}"';
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
          fileContent[i] = 'BASE_PACKAGES="${Configs.basePackages}"';
        } else if (line.contains('BASE_FILES="')) {
          fileContent[i] = 'BASE_FILES="${Configs.baseFiles}"';
        } else if (line.contains('BASE_REMOVE="')) {
          fileContent[i] = 'BASE_REMOVE="${Configs.baseRemove}"';
        } else if (line.contains('SUBPROJECTS="')) {
          fileContent[i] = 'SUBPROJECTS="${Configs.subprojects}"';
        } else if (line.contains('KERNEL_DEFAULT_CONFIG_METHOD="')) {
          fileContent[i] =
              'KERNEL_DEFAULT_CONFIG_METHOD="${Configs.kernelDefaultConfigMethod}"';
        } else if (line.contains('KERNEL_INTEGRATION="')) {
          fileContent[i] = 'KERNEL_INTEGRATION="${Configs.kernelIntegration}"';
        } else if (line.contains('KERNEL_SOURCE="')) {
          fileContent[i] = 'KERNEL_SOURCE="${Configs.kernelSource}"';
          if (!Configs.kernelSourceActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
        } else if (line.contains('KERNEL_CONFIG="')) {
          fileContent[i] = 'KERNEL_CONFIG="${Configs.kernelConfig}"';
          if (!Configs.kernelConfigActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
        } else if (line.contains('KERNEL_DEVICETREE="')) {
          fileContent[i] = 'KERNEL_DEVICETREE="${Configs.kernelDevicetree}"';
          if (!Configs.kernelDeviceTreeActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
        } else if (line.contains('KERNEL_BOOT_LOGO="')) {
          fileContent[i] = 'KERNEL_BOOT_LOGO="${Configs.kernelBootLogo}"';
          if (!Configs.kernelBootLogoActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
        } else if (line.contains('KERNEL_IMAGE="')) {
          fileContent[i] = 'KERNEL_IMAGE="${Configs.kernelImage}"';
          if (!Configs.kernelImageActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
        } else if (line.contains('KERNEL_MODULES="')) {
          fileContent[i] = 'KERNEL_MODULES="${Configs.kernelModules}"';
          if (!Configs.kernelModulesActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
        } else if (line.contains('OUTPUT_EXT2="')) {
          String answer = getYesNoFromBool(Configs.outputExt2);
          fileContent[i] = 'OUTPUT_EXT2="$answer"';
        } else if (line.contains('OUTPUT_JFFS2="')) {
          String answer = getYesNoFromBool(Configs.outputJffs2);
          fileContent[i] = 'OUTPUT_JFFS2="$answer"';
        } else if (line.contains('OUTPUT_JFFS2_BACKEND="')) {
          fileContent[i] =
              'OUTPUT_JFFS2_BACKEND="${Configs.outputJffs2Backend}"';
        } else if (line.contains('OUTPUT_JFFS2_COMPRESSION="')) {
          String answer = getYesNoFromBool(Configs.outputJffs2Compression);
          fileContent[i] = 'OUTPUT_JFFS2_COMPRESSION="$answer"';
        } else if (line.contains('OUTPUT_JFFS2_SUMMARY="')) {
          String answer = getYesNoFromBool(Configs.outputJffs2Summary);
          fileContent[i] = 'OUTPUT_JFFS2_SUMMARY="$answer"';
        } else if (line.contains('OUTPUT_UBIFS="')) {
          String answer = getYesNoFromBool(Configs.outputUbifs);
          fileContent[i] = 'OUTPUT_UBIFS="$answer"';
        } else if (line.contains('OUTPUT_UBIFS_COMPRESSION="')) {
          String answer = getYesNoFromBool(Configs.outputUbifsCompression);
          fileContent[i] = 'OUTPUT_UBIFS_COMPRESSION="$answer"';
        } else if (line.contains('OUTPUT_CRAMFS="')) {
          String answer = getYesNoFromBool(Configs.outputCramfs);
          fileContent[i] = 'OUTPUT_CRAMFS="$answer"';
        } else if (line.contains('OUTPUT_SQUASHFS="')) {
          String answer = getYesNoFromBool(Configs.outputSquashfs);
          fileContent[i] = 'OUTPUT_SQUASHFS="$answer"';
        } else if (line.contains('OUTPUT_CPIO="')) {
          String answer = getYesNoFromBool(Configs.outputCpio);
          fileContent[i] = 'OUTPUT_CPIO="$answer"';
        } else if (line.contains('GELIN_PROJECT_NFSROOT="')) {
          fileContent[i] =
              'GELIN_PROJECT_NFSROOT="${Configs.gelinProjectNfsroot}"';
          if (!Configs.gelinProjectNfsrootActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
        } else if (line.contains('GELIN_PROJECT_TFTPROOT="')) {
          fileContent[i] =
              'GELIN_PROJECT_TFTPROOT="${Configs.gelinProjectTftproot}"';
          if (!Configs.gelinProjectTftprootActivated) {
            fileContent[i] = '#${fileContent[i]}';
          }
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
    Configs configs = new Configs();
    configs.reset();
    configs.init(widget.path, _configParseDoneCallback);
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
              Configs.projectBuildVersion.length > 0
                  ? Row(
                      children: [
                        Text('GELin version: '),
                        VersionPicker(setVersion, Configs.projectBuildVersion),
                      ],
                    )
                  : Container(),
              Container(
                  child: FilePickerList('Packages', _availablePackages,
                      Configs.basePackages.split(' '), setPackages)),
              AddRemoveList(Configs.subprojects.split(' '), 'Subprojects',
                  removeSubproject, addSubproject),
              AddRemoveList(Configs.baseRemove.split(' '), 'Removed files',
                  removeFromRemovedList, addToRemovedList),
              Row(
                children: [
                  Text('Update image: '),
                  DropdownPicker(UpdateCreation.availableUpdateImageTypes,
                      _chosenUpdateId, _updateImagePickerCallback),
                ],
              ),
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
