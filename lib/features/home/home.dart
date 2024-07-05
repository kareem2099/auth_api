import 'package:auth_api/features/auth/presentation/component/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:auth_api/features/auth/presentation/screens/delete_screen.dart';
import 'package:auth_api/features/auth/presentation/screens/get_user_data_screen.dart';
import 'package:auth_api/features/auth/presentation/screens/update_screen.dart';
import 'package:auth_api/features/auth/presentation/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = "homePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout logic here
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Home!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildNavigationButton(
                context,
                UpdateUserScreen.routeName,
                'Update User',
                Icons.update,
              ),
              const SizedBox(height: 20),
              _buildNavigationButton(
                context,
                DeleteUserScreen.routeName,
                'Delete User',
                Icons.delete,
              ),
              const SizedBox(height: 20),
              _buildNavigationButton(
                context,
                GetUserDataScreen.routeName,
                'Get User Data',
                Icons.person,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String route, String text, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () async {
        bool hasPermission =
            await PermissionHandlerUtil.requestStoragePermission();

        if (hasPermission) {
          Navigator.pushNamed(context, route);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Storage Permission Required'),
              content: const Text(
                  'This app needs storage access to continue. Please grant the permission.'),
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
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
