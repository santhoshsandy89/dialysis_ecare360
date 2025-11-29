import 'dart:convert';

import 'package:ecare360/core/utils/logger.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl =
      'https://user.dev-hmis.yanthralabs.com/api/v1/users';

  Future<List<Map<String, dynamic>>> fetchPatients(String accessToken) async {
    final url =
        Uri.parse('$_baseUrl?usertype=Patient&isActive=true&page=1&limit=100');
    return _fetchUsers(url, accessToken, 'patients');
  }

  Future<List<Map<String, dynamic>>> fetchDoctors(String accessToken) async {
    final url = Uri.parse(
        '$_baseUrl?role=Doctor&usertype=Doctor&isActive=true&page=1&limit=100');
    return _fetchUsers(url, accessToken, 'doctors');
  }

  Future<List<Map<String, dynamic>>> _fetchUsers(
      Uri url, String accessToken, String userType) async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    AppLogger.debug('🔸 UserService: Fetching $userType from $url');

    try {
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
      AppLogger.debug(
          '🔸 UserService: $userType Response status: ${response.statusCode}');
      AppLogger.debug(
          '🔸 UserService: $userType Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        AppLogger.debug(
            '🔸 UserService: $userType responseBody success: ${responseBody['success']}');
        AppLogger.debug(
            '🔸 UserService: $userType responseBody message: ${responseBody['message']}');
        AppLogger.debug(
            '🔸 UserService: $userType responseBody data (type): ${responseBody['data'].runtimeType}');
        AppLogger.debug(
            '🔸 UserService: $userType responseBody data (value): ${responseBody['data']}');
        if (responseBody['data'] != null) {
          final List<dynamic> usersData = responseBody['data'];
          return usersData.cast<Map<String, dynamic>>();
        } else {
          throw Exception(responseBody['message'] ??
              'Failed to fetch $userType: Success was false.');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception(
            'Failed to fetch $userType: ${response.statusCode} ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error fetching $userType: ${e.message}');
    } on FormatException {
      throw Exception('Invalid response format from server for $userType.');
    } on Exception catch (e) {
      throw Exception(
          'An unexpected error occurred fetching $userType: ${e.toString()}');
    }
  }
}
