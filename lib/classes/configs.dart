import 'dart:io';

class Configs {
  //build.sh
  static String projectName = '';
  static String projectVersion = '';
  static String projectVersionString = '';
  static String projectBuildVersion = '';
  static String projectUpdateRootfsType = '';
  static String projectUpdateArgs = '';

  //gelin_project.conf
  static String basePackages = '';
  static String baseFiles = '';
  static String baseRemove = '';
  static String subprojects = '';

  static String kernelDefaultConfigMethod = '';
  static String kernelIntegration = '';
  static String kernelSource = '';
  static String kernelConfig = '';
  static String kernelDevicetree = '';
  static String kernelBootLogo = '';
  static String kernelImage = '';
  static String kernelModules = '';

  static bool outputExt2 = false;
  static bool outputJffs2 = false;
  static String outputJffs2Backend = '';
  static bool outputJffs2Compression = false;
  static bool outputJffs2Summary = false;
  static bool outputUbifs = false;
  static bool outputUbifsCompression = false;
  static bool outputCramfs = false;
  static bool outputSquashfs = false;
  static bool outputCpio = false;

  static String gelinProjectNfsroot = '';
  static String gelinProjectTftproot = '';

  static bool kernelSourceActivated = false;
  static bool kernelConfigActivated = false;
  static bool kernelDeviceTreeActivated = false;
  static bool kernelBootLogoActivated = false;
  static bool kernelImageActivated = false;
  static bool kernelModulesActivated = false;
  static bool gelinProjectNfsrootActivated = false;
  static bool gelinProjectTftprootActivated = false;

  //housekeeping
  static bool initialized = false;
  static bool buildShDone = false;
  static bool projectConfDone = false;
  static Function doneCallback;

  String getArgument(String fullLine) {
    if (fullLine.length < 2) {
      return '';
    }
    return fullLine.substring(
        fullLine.indexOf('"') + 1, fullLine.lastIndexOf('"'));
  }

  bool _lineIsActive(String line) {
    if (line.contains('#')) {
      return false;
    } else {
      return true;
    }
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
          kernelSourceActivated = _lineIsActive(line);
        } else if (line.contains('KERNEL_CONFIG="')) {
          kernelConfig = getArgument(line);
          kernelConfigActivated = _lineIsActive(line);
        } else if (line.contains('KERNEL_DEVICETREE="')) {
          kernelDevicetree = getArgument(line);
          kernelDeviceTreeActivated = _lineIsActive(line);
        } else if (line.contains('KERNEL_BOOT_LOGO="')) {
          kernelBootLogo = getArgument(line);
          kernelBootLogoActivated = _lineIsActive(line);
        } else if (line.contains('KERNEL_IMAGE="')) {
          kernelImage = getArgument(line);
          kernelImageActivated = _lineIsActive(line);
        } else if (line.contains('KERNEL_MODULES="')) {
          kernelModules = getArgument(line);
          kernelModulesActivated = _lineIsActive(line);
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
          gelinProjectNfsrootActivated = _lineIsActive(line);
        } else if (line.contains('GELIN_PROJECT_TFTPROOT="')) {
          gelinProjectTftproot = getArgument(line);
          gelinProjectTftprootActivated = _lineIsActive(line);
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

  Configs();

  Future<void> init(String projectPath, Function doneCallback) async {
    if (initialized) {
      return;
    }
    initialized = true;
    Configs.doneCallback = doneCallback;
    _parseBuildSh(projectPath);
    _parseProjectConf(projectPath);
  }

  void reset() {
    projectName = '';
    projectVersion = '';
    projectVersionString = '';
    projectBuildVersion = '';
    projectUpdateRootfsType = '';
    projectUpdateArgs = '';
    basePackages = '';
    baseFiles = '';
    baseRemove = '';
    subprojects = '';
    kernelDefaultConfigMethod = '';
    kernelIntegration = '';
    kernelSource = '';
    kernelConfig = '';
    kernelDevicetree = '';
    kernelBootLogo = '';
    kernelImage = '';
    kernelModules = '';
    outputExt2 = false;
    outputJffs2 = false;
    outputJffs2Backend = '';
    outputJffs2Compression = false;
    outputJffs2Summary = false;
    outputUbifs = false;
    outputUbifsCompression = false;
    outputCramfs = false;
    outputSquashfs = false;
    outputCpio = false;
    gelinProjectNfsroot = '';
    gelinProjectTftproot = '';
    initialized = false;
    buildShDone = false;
    projectConfDone = false;
    doneCallback = null;
    kernelSourceActivated = false;
    kernelConfigActivated = false;
    kernelDeviceTreeActivated = false;
    kernelBootLogoActivated = false;
    kernelImageActivated = false;
    kernelModulesActivated = false;
    gelinProjectNfsrootActivated = false;
    gelinProjectTftprootActivated = false;
  }

  bool get parsingDone {
    return buildShDone && projectConfDone;
  }
}
