// import 'package:auth_api/features/auth/presentation/component/secure_storage_helper.dart';
// import 'package:http/http.dart' as http;

// class ApiHelper {
//   static Future<http.Response> fetchData(String endpoint) async {
//     final token = await SecureStorageHelper.readToken();
//     print("Retrieved Token: $token");
//     final response = await http.get(
//       Uri.parse(endpoint),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );
//     return response;
//   }
// }
