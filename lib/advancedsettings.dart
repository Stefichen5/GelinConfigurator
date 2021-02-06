import 'package:flutter/material.dart';
import './classes/configs.dart';

class AdvancedSettings extends StatefulWidget {
  AdvancedSettings();

  @override
  _AdvancedSettingsState createState() => _AdvancedSettingsState();
}

class _AdvancedSettingsState extends State<AdvancedSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
      ),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text(
            'Advanced settings',
            style: Theme.of(context).textTheme.headline6,
          ),
          TextFormField(
            initialValue: Configs.projectUpdateArgs,
            decoration: InputDecoration(labelText: 'PROJECT_UPDATE_ARGS'),
            onChanged: (value) => Configs.projectUpdateArgs = value,
          ),
          TextFormField(
            initialValue: Configs.kernelDefaultConfigMethod,
            decoration:
                InputDecoration(labelText: 'KERNEL_DEFAULT_CONFIG_METHOD'),
            onChanged: (value) => Configs.kernelDefaultConfigMethod = value,
          ),
          TextFormField(
            initialValue: Configs.kernelIntegration,
            decoration: InputDecoration(labelText: 'KERNEL_INTEGRATION'),
            onChanged: (value) => Configs.kernelIntegration = value,
          ),
          TextFormField(
            initialValue: Configs.kernelSource,
            decoration: InputDecoration(labelText: 'KERNEL_SOURCE'),
            onChanged: (value) => Configs.kernelSource = value,
          ),
          TextFormField(
            initialValue: Configs.kernelConfig,
            decoration: InputDecoration(labelText: 'KERNEL_CONFIG'),
            onChanged: (value) => Configs.kernelConfig = value,
          ),
          TextFormField(
            initialValue: Configs.kernelDevicetree,
            decoration: InputDecoration(labelText: 'KERNEL_DEVICETREE'),
            onChanged: (value) => Configs.kernelDevicetree = value,
          ),
          TextFormField(
            initialValue: Configs.kernelBootLogo,
            decoration: InputDecoration(labelText: 'KERNEL_BOOT_LOGO'),
            onChanged: (value) => Configs.kernelBootLogo = value,
          ),
          TextFormField(
            initialValue: Configs.kernelImage,
            decoration: InputDecoration(labelText: 'KERNEL_IMAGE'),
            onChanged: (value) => Configs.kernelImage = value,
          ),
          TextFormField(
            initialValue: Configs.kernelModules,
            decoration: InputDecoration(labelText: 'KERNEL_MODULES'),
            onChanged: (value) => Configs.kernelModules = value,
          ),
          CheckboxListTile(
            title: Text('OUTPUT_EXT2'),
            value: Configs.outputExt2,
            onChanged: (state) {
              setState(() {
                Configs.outputExt2 = state;
              });
            },
          ),
          CheckboxListTile(
              title: Text('OUTPUT_JFFS2'),
              value: Configs.outputJffs2,
              onChanged: (state) {
                setState(() {
                  Configs.outputJffs2 = state;
                });
              }),
          TextFormField(
            initialValue: Configs.outputJffs2Backend,
            decoration: InputDecoration(labelText: 'OUTPUT_JFFS2_BACKEND'),
            onChanged: (value) => Configs.outputJffs2Backend = value,
          ),
          CheckboxListTile(
              title: Text('OUTPUT_JFFS2_COMPRESSION'),
              value: Configs.outputJffs2Compression,
              onChanged: (state) {
                setState(() {
                  Configs.outputJffs2Compression = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_JFFS2_SUMMARY'),
              value: Configs.outputJffs2Summary,
              onChanged: (state) {
                setState(() {
                  Configs.outputJffs2Summary = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_UBIFS'),
              value: Configs.outputUbifs,
              onChanged: (state) {
                setState(() {
                  Configs.outputUbifs = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_UBIFS_COMPRESSION'),
              value: Configs.outputUbifsCompression,
              onChanged: (state) {
                setState(() {
                  Configs.outputUbifsCompression = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_CRAMFS'),
              value: Configs.outputCramfs,
              onChanged: (state) {
                setState(() {
                  Configs.outputCramfs = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_SQUASHFS'),
              value: Configs.outputSquashfs,
              onChanged: (state) {
                setState(() {
                  Configs.outputSquashfs = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_CPIO'),
              value: Configs.outputCpio,
              onChanged: (state) {
                setState(() {
                  Configs.outputCpio = state;
                });
              }),
          TextFormField(
            initialValue: Configs.gelinProjectNfsroot,
            decoration: InputDecoration(labelText: 'GELIN_PROJECT_NFSROOT'),
            onChanged: (value) => Configs.gelinProjectNfsroot = value,
          ),
          TextFormField(
            initialValue: Configs.gelinProjectTftproot,
            decoration: InputDecoration(labelText: 'GELIN_PROJECT_TFTPROOT'),
            onChanged: (value) => Configs.gelinProjectTftproot = value,
          ),
        ],
      ),
    );
  }
}
