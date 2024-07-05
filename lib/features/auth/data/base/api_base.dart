import 'dart:convert';
import 'package:auth_api/features/auth/data/constatnt/const.dart';
import 'package:auth_api/features/auth/presentation/component/secure_storage_helper.dart';
import 'package:http/http.dart' as http;

class ApiBase {
  Future<Map<String, String>> _getHeadersPost() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<Map<String, String>> _getHeadersPatch() async {
    final token = await SecureStorageHelper.readToken();
    return {
      'Content-Type': 'application/json',
      'token': ' $token',
    };
  }

  Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');
    final headers = await _getHeadersPost();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> patchRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');
    final headers = await _getHeadersPatch();
    final response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> deleteRequest(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');
    final headers = await _getHeadersPatch();
    final uri = url.replace(queryParameters: queryParams);
    final response = await http.delete(
      uri,
      headers: headers,
    );
    return response;
  }

  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');
    final headers = await _getHeadersPatch();
    final response = await http.get(url, headers: headers);
    return response;
  }
}
