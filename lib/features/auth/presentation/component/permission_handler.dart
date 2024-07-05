import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerUtil {
  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status.isDenied || status.isRestricted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      return statuses[Permission.storage]?.isGranted ?? false;
    }

    return status.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied || status.isRestricted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();

      return statuses[Permission.location]?.isGranted ?? false;
    }

    return status.isGranted;
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
