import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  static Future<String?> readToken() async {
    final token = await _secureStorage.read(key: 'token');
    if (token != null && token.isNotEmpty) {
      return 'FOODAPI $token';
    }
    return null;
  }

  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'token');
  }
}
