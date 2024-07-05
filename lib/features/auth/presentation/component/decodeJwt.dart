import 'dart:convert';

Map<String, dynamic> decodeJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid JWT token');
  }
  final payload = parts[1];

  var normalizedPayload = base64Url.normalize(payload);
  var decoded = utf8.decode(base64Url.decode(normalizedPayload));

  return json.decode(decoded);
}
