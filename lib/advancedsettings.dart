import 'package:flutter/material.dart';
import './classes/configs.dart';

class AdvancedSettings extends StatefulWidget {
  final Configs projectConfig;

  AdvancedSettings(this.projectConfig);

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
          TextField(
            decoration:
                InputDecoration(labelText: 'PROJECT_UPDATE_ROOTFS_TYPE'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'PROJECT_UPDATE_ARGS'),
          ),
          TextField(
            decoration:
                InputDecoration(labelText: 'KERNEL_DEFAULT_CONFIG_METHOD'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'KERNEL_INTEGRATION'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'KERNEL_SOURCE'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'KERNEL_CONFIG'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'KERNEL_DEVICETREE'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'KERNEL_BOOT_LOGO'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'KERNEL_IMAGE'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'KERNEL_MODULES'),
          ),
          CheckboxListTile(
            title: Text('OUTPUT_EXT2'),
            value: widget.projectConfig.outputExt2,
            onChanged: (state) {
              setState(() {
                widget.projectConfig.outputExt2 = state;
              });
            },
          ),
          CheckboxListTile(
              title: Text('OUTPUT_JFFS2'),
              value: widget.projectConfig.outputJffs2,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputJffs2 = state;
                });
              }),
          TextField(
            decoration: InputDecoration(labelText: 'OUTPUT_JFFS2_BACKEND'),
          ),
          CheckboxListTile(
              title: Text('OUTPUT_JFFS2_COMPRESSION'),
              value: widget.projectConfig.outputJffs2Compression,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputJffs2Compression = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_JFFS2_SUMMARY'),
              value: widget.projectConfig.outputJffs2Summary,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputJffs2Summary = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_UBIFS'),
              value: widget.projectConfig.outputUbifs,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputUbifs = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_UBIFS_COMPRESSION'),
              value: widget.projectConfig.outputUbifsCompression,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputUbifsCompression = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_CRAMFS'),
              value: widget.projectConfig.outputCramfs,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputCramfs = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_SQUASHFS'),
              value: widget.projectConfig.outputSquashfs,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputSquashfs = state;
                });
              }),
          CheckboxListTile(
              title: Text('OUTPUT_CPIO'),
              value: widget.projectConfig.outputCpio,
              onChanged: (state) {
                setState(() {
                  widget.projectConfig.outputCpio = state;
                });
              }),
          TextField(
            decoration: InputDecoration(labelText: 'GELIN_PROJECT_NFSROOT'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'GELIN_PROJECT_TFTPROOT'),
          ),
        ],
      ),
    );
  }
}
