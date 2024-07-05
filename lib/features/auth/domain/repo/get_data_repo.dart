import 'package:auth_api/features/auth/data/base/api_base.dart';
import 'package:auth_api/features/auth/data/constatnt/const.dart';

class GetUserRepo {
  final ApiBase apiBase = ApiBase();

  Future<List<dynamic>> getUserData(String userId) async {
    final response =
        await apiBase.getRequest('${ApiConstants.getUser}/$userId');

    // Print the response body and status code
    print("Response get data Body: ${response.body}");
    print("Status get data Code: ${response.statusCode}");

    if (response.statusCode == 202) {
      return [response.body, response.statusCode];
    } else if (response.statusCode == 400) {
      return ['Invalid user ID', response.statusCode];
    } else {
      return ['An unexpected error occurred', response.statusCode];
    }
  }
}
