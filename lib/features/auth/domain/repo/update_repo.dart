import 'dart:convert';
import 'dart:io';
import 'package:auth_api/features/auth/presentation/component/secure_storage_helper.dart';
import 'package:http/http.dart' as http;

import 'package:auth_api/features/auth/data/base/api_base.dart';
import 'package:auth_api/features/auth/data/constatnt/const.dart';

class UpdateRepo {
  final ApiBase apiBase = ApiBase();

  Future<List<dynamic>> updateUserData({
    required String name,
    required String phone,
    required Map<String, dynamic> location,
    File? profilePic,
  }) async {
    final request = http.MultipartRequest('PATCH',
        Uri.parse('${ApiConstants.baseUrl}/${ApiConstants.updateUser}'));
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['location'] = jsonEncode(location);

    if (profilePic != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profilePic', profilePic.path));
    }
    final token = await SecureStorageHelper.readToken();

    // Add token to headers
    request.headers['token'] = ' $token';

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Print the response body and status code
    // Print the response body and status code
    print("Response update Body: ${response.body}");
    print("Status update Code: ${response.statusCode}");

    if (response.statusCode == 202) {
      return [response.body, response.statusCode];
    } else if (response.statusCode == 400) {
      final responseBody = jsonDecode(response.body);
      return [
        responseBody['ErrorMessage'] ?? 'Update failed',
        response.statusCode
      ];
    } else {
      return ['An unexpected error occurred', response.statusCode];
    }
  }

  Future<List<dynamic>> getUserData(String userId) async {
    final response =
        await apiBase.getRequest('${ApiConstants.getUser}/$userId');

    // Print the response body and status code

    if (response.statusCode == 202) {
      return [response.body, response.statusCode];
    } else if (response.statusCode == 400) {
      return ['Invalid user ID', response.statusCode];
    } else {
      return ['An unexpected error occurred', response.statusCode];
    }
  }
}
