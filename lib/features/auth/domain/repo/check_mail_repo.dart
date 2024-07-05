import 'package:auth_api/features/auth/data/base/api_base.dart';
import 'package:auth_api/features/auth/data/constatnt/const.dart';

class CheckMailRepo {
  final ApiBase apiBase = ApiBase();

  Future<List<dynamic>> checkMail({required String email}) async {
    final response = await apiBase.postRequest(ApiConstants.checkEmail, {
      'email': email,
    });

    // Print the response body and status code// Print the response body and status code
    print("Response check mail Body: ${response.body}");
    print("Status check mail Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      return [response.body, response.statusCode];
    } else if (response.statusCode == 400) {
      return ['Invalid email address', response.statusCode];
    } else {
      return ['An unexpected error occurred', response.statusCode];
    }
  }
}
