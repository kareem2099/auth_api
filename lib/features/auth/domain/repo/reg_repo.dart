import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:auth_api/features/auth/data/base/api_base.dart';
import 'package:auth_api/features/auth/data/constatnt/const.dart';

class RegisterRepo {
  final ApiBase apiBase = ApiBase();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required Map<String, dynamic> location,
    File? profilePic,
  }) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConstants.baseUrl}/${ApiConstants.signUp}'));
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['phone'] = phone;
    request.fields['password'] = password;
    request.fields['confirmPassword'] = confirmPassword;
    request.fields['location'] = jsonEncode(location);

    if (profilePic != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profilePic', profilePic.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

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
