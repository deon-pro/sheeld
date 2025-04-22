import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  PermissionStatus _microphonePermissionStatus = PermissionStatus.denied;
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    _cameraPermissionStatus = await Permission.camera.request();
    _microphonePermissionStatus = await Permission.microphone.request();
    _storagePermissionStatus = await Permission.storage.request();

    setState(() {});
  }

  Widget _buildPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return const Text('Allowed');
      case PermissionStatus.denied:
        return const Text('Denied');
      case PermissionStatus.permanentlyDenied:
        return const Text('Permanently Denied');
      case PermissionStatus.restricted:
        return const Text('Restricted');
      default:
        return const Text('Unknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Page'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Camera'),
            subtitle: _buildPermissionStatus(_cameraPermissionStatus),
          ),
          ListTile(
            title: const Text('Microphone'),
            subtitle: _buildPermissionStatus(_microphonePermissionStatus),
          ),
          ListTile(
            title: const Text('Storage'),
            subtitle: _buildPermissionStatus(_storagePermissionStatus),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _requestPermissions,
        tooltip: 'Request Permissions',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
