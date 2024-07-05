import 'package:auth_api/features/auth/data/base/api_base.dart';
import 'package:auth_api/features/auth/data/constatnt/const.dart';
import 'dart:convert';

class LoginRepo {
  final ApiBase apiBase = ApiBase();

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final response = await apiBase.postRequest(ApiConstants.signIn, {
      'email': email,
      'password': password,
    });

    // Print the response body and status code

    try {
      final responseBody = jsonDecode(response.body);
      return {
        'body': responseBody,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'body': 'An unexpected error occurred',
        'statusCode': response.statusCode,
      };
    }
  }
}
