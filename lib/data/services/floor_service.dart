import 'dart:convert';

import 'package:http/http.dart' as http;

class FloorService {
  static const String _baseUrl = 'https://configurations.dev-hmis.yanthralabs.com';
  static const String _floorEndpoint = '/api/v1/entity/values?entityCategory=31';

  Future<List<Map<String, dynamic>>> fetchFloors(String accessToken) async {
    final url = Uri.parse('$_baseUrl$_floorEndpoint');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    print('🔸 FloorService: Fetching floors with headers: $headers');

    try {
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      print('🔸 Response status: ${response.statusCode}');
      print('🔸 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);
        return responseBody.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception('Failed to fetch floors: ${response.statusCode} ${response.body}');
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
