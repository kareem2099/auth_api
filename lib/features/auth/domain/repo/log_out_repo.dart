import 'package:auth_api/features/auth/data/base/api_base.dart';
import 'package:auth_api/features/auth/data/constatnt/const.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogoutRepo {
  final ApiBase apiBase = ApiBase();
  final _secureStorage = const FlutterSecureStorage();

  Future<List<dynamic>> logout() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) {
      return ['Token is missing', 401];
    }

    final response = await apiBase.postRequest(ApiConstants.logout, {
      'token': token,
    });

    // Print the response body and status code
    // Print the response body and status code

    if (response.statusCode == 200) {
      await _secureStorage.deleteAll();
      return [response.body, response.statusCode];
    } else if (response.statusCode == 400) {
      return ['Invalid token', response.statusCode];
    } else {
      return ['An unexpected error occurred', response.statusCode];
    }
  }
}
