import 'dart:io';

class Configs {
  //build.sh
  String projectName = '';
  String projectVersion = '';
  String projectVersionString = '';
  String projectBuildVersion = '';
  String projectUpdateRootfsType = '';
  String projectUpdateArgs = '';

  //gelin_project.conf
  String basePackages = '';
  String baseFiles = '';
  String baseRemove = '';
  String subprojects = '';

  String kernelDefaultConfigMethod = '';
  String kernelIntegration = '';
  String kernelSource = '';
  String kernelConfig = '';
  String kernelDevicetree = '';
  String kernelBootLogo = '';
  String kernelImage = '';
  String kernelModules = '';

  bool outputExt2 = false;
  bool outputJffs2 = false;
  String outputJffs2Backend = '';
  bool outputJffs2Compression = false;
  bool outputJffs2Summary = false;
  bool outputUbifs = false;
  bool outputUbifsCompression = false;
  bool outputCramfs = false;
  bool outputSquashfs = false;
  bool outputCpio = false;

  String gelinProjectNfsroot = '';
  String gelinProjectTftproot = '';

  //housekeeping
  bool buildShDone = false;
  bool projectConfDone = false;
  Function doneCallback;

  String getArgument(String fullLine) {
    if (fullLine.length < 2) {
      return '';
    }
    return fullLine.substring(
        fullLine.indexOf('"') + 1, fullLine.lastIndexOf('"'));
  }

  Future<void> _parseBuildSh(String path) async {
    try {
      var buildShFile = File('$path/build.sh');
      var lines = await buildShFile.readAsLines();

      for (final line in lines) {
        if (line.contains('PROJECT_NAME=')) {
          projectName = getArgument(line);
        } else if (line.contains('PROJECT_VERSION=')) {
          projectVersion = getArgument(line);
        } else if (line.contains('PROJECT_BUILD_VERSION=')) {
          projectBuildVersion = getArgument(line);
        } else if (line.contains('PROJECT_VERSION_STRING=')) {
          projectVersionString =
              line.substring(line.indexOf('} ') + 2, line.lastIndexOf('"'));
        } else if (line.contains('PROJECT_UPDATE_ROOTFS_TYPE="')) {
          projectUpdateRootfsType = getArgument(line);
        } else if (line.contains('PROJECT_UPDATE_ARGS="')) {
          projectUpdateArgs = getArgument(line);
        }

        buildShDone = true;

        if (parsingDone) {
          doneCallback();
        }
      }
    } catch (e) {
      print('Error in parseBuildSh');
    }
  }

  Future<void> _parseProjectConf(String path) async {
    try {
      var projectConfFile = File('$path/gelin_project.conf');
      var lines = await projectConfFile.readAsLines();

      for (final line in lines) {
        if (line.contains('BASE_PACKAGES="')) {
          basePackages = getArgument(line);
        } else if (line.contains('BASE_FILES="')) {
          baseFiles = getArgument(line);
        } else if (line.contains('BASE_REMOVE="')) {
          baseRemove = getArgument(line);
        } else if (line.contains('SUBPROJECTS="')) {
          subprojects = getArgument(line);
        } else if (line.contains('KERNEL_DEFAULT_CONFIG_METHOD="')) {
          kernelDefaultConfigMethod = getArgument(line);
        } else if (line.contains('KERNEL_INTEGRATION="')) {
          kernelIntegration = getArgument(line);
        } else if (line.contains('KERNEL_SOURCE="')) {
          kernelSource = getArgument(line);
        } else if (line.contains('KERNEL_CONFIG="')) {
          kernelConfig = getArgument(line);
        } else if (line.contains('KERNEL_DEVICETREE="')) {
          kernelDevicetree = getArgument(line);
        } else if (line.contains('KERNEL_BOOT_LOGO="')) {
          kernelBootLogo = getArgument(line);
        } else if (line.contains('KERNEL_IMAGE="')) {
          kernelImage = getArgument(line);
        } else if (line.contains('KERNEL_MODULES="')) {
          kernelModules = getArgument(line);
        } else if (line.contains('OUTPUT_EXT2="')) {
          outputExt2 = line.contains('yes');
        } else if (line.contains('OUTPUT_JFFS2="')) {
          outputJffs2 = line.contains('yes');
        } else if (line.contains('OUTPUT_JFFS2_BACKEND="')) {
          outputJffs2Backend = getArgument(line);
        } else if (line.contains('OUTPUT_JFFS2_COMPRESSION="')) {
          outputJffs2Compression = line.contains('yes');
        } else if (line.contains('OUTPUT_JFFS2_SUMMARY="')) {
          outputJffs2Summary = line.contains('yes');
        } else if (line.contains('OUTPUT_UBIFS="')) {
          outputUbifs = line.contains('yes');
        } else if (line.contains('OUTPUT_UBIFS_COMPRESSION="')) {
          outputUbifsCompression = line.contains('yes');
        } else if (line.contains('OUTPUT_CRAMFS="')) {
          outputCramfs = line.contains('yes');
        } else if (line.contains('OUTPUT_SQUASHFS="')) {
          outputSquashfs = line.contains('yes');
        } else if (line.contains('OUTPUT_CPIO="')) {
          outputCpio = line.contains('yes');
        } else if (line.contains('GELIN_PROJECT_NFSROOT="')) {
          gelinProjectNfsroot = getArgument(line);
        } else if (line.contains('GELIN_PROJECT_TFTPROOT="')) {
          gelinProjectTftproot = getArgument(line);
        }
      }
      projectConfDone = true;

      if (parsingDone) {
        doneCallback();
      }
    } catch (e) {
      print('Error in _parseProjectConf');
    }
  }

  Configs(String projectPath, Function doneCallback) {
    this.doneCallback = doneCallback;
    _parseBuildSh(projectPath);
    _parseProjectConf(projectPath);
  }

  bool get parsingDone {
    return buildShDone && projectConfDone;
  }
}
