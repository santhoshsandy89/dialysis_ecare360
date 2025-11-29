import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl =
      'https://auth.dev-hmis.yanthralabs.com/v1/user';
  static const String _tenantKey = 'bcfdb3c7-ff4f-11ef-891d-028579933a83';

  Future<Map<String, dynamic>> verifyUserIdentity({
    String? email,
    String? phone,
  }) async {
    final url = Uri.parse('$_baseUrl/identity');
    final Map<String, dynamic> body = {'tenantKey': _tenantKey};

    if (email != null && email.isNotEmpty) {
      body['email'] = email;
    } else if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    } else {
      throw Exception('Either email or phone must be provided.');
    }
// 🟦 Print Request Info
    print('🔹 Sending POST request to: $url');
    print('🔹 Request body: ${json.encode(body)}');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 10)); // 10 seconds timeout
      print('🔸 Response status: ${response.statusCode}');
      print('🔸 Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          return responseBody;
        } else {
          throw Exception(responseBody['error'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception(
            'Failed to verify identity: ${response.statusCode} ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } on Exception catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> verifyUserPassword({
    required String userId,
    required String password,
    required String host,
  }) async {
    final url = Uri.parse('$_baseUrl/password');
    final Map<String, dynamic> body = {
      'userid': userId,
      'password': password,
      'host': host,
    };

    try {
      // 🟦 Print Request Info
      print('🔹 Sending POST request to: $url');
      print('🔹 Request body: ${json.encode(body)}');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 10)); // 10 seconds timeout

      // 🟦 Print Request Info
      print('🔸 Response status: ${response.statusCode}');
      print('🔸 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          return responseBody;
        } else {
          throw Exception(responseBody['error'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception(
            'Failed to verify password: ${response.statusCode} ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } on Exception catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
