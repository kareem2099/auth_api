import 'package:flutter/material.dart';
import 'package:auth_api/features/auth/presentation/component/permission_handler.dart';
import 'package:auth_api/features/auth/presentation/screens/login_screen.dart';

class PermissionCheckScreen extends StatefulWidget {
  static const String routeName = '/';

  const PermissionCheckScreen({super.key});

  @override
  _PermissionCheckScreenState createState() => _PermissionCheckScreenState();
}

class _PermissionCheckScreenState extends State<PermissionCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool storagePermission =
        await PermissionHandlerUtil.requestStoragePermission();
    bool locationPermission =
        await PermissionHandlerUtil.requestLocationPermission();

    if (storagePermission && locationPermission) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
            'This app needs storage and location access to continue. Please grant the permissions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              PermissionHandlerUtil.openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
