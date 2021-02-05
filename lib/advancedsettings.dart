import 'package:flutter/material.dart';

class AdvancedSettings extends StatefulWidget {
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
          Text('... TODO'),
        ],
      ),
    );
  }
}
