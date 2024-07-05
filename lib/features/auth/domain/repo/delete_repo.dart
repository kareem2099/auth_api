import 'package:auth_api/features/auth/data/base/api_base.dart';
import 'package:auth_api/features/auth/data/constatnt/const.dart';

class DeleteRepo {
  final ApiBase apiBase = ApiBase();

  Future<List<dynamic>> deleteUser(String userId) async {
    final response = await apiBase
        .deleteRequest(ApiConstants.deleteUser, queryParams: {'id': userId});

    // Print the response body and status code
    print("Response del Body: ${response.body}");
    print("Status del Code: ${response.statusCode}");

    if (response.statusCode == 202) {
      return [response.body, response.statusCode];
    } else if (response.statusCode == 404) {
      return ['Invalid user ID', response.statusCode];
    } else {
      return ['An unexpected error occurred', response.statusCode];
    }
  }
}
