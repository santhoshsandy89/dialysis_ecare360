import 'dart:convert';
import 'package:http/http.dart' as http;

class BedService {
  static const String _baseUrl = 'https://patientportal.dev-hmis.yanthralabs.com/api/v1/room-management';
  static const String _bedsEndpoint = '/beds';

  Future<Map<String, dynamic>> fetchBeds(String accessToken) async {
    final url = Uri.parse('$_baseUrl$_bedsEndpoint');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    print('🔸 BedService: Fetching beds with headers: $headers');

    try {
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      print('🔸 BedService: Response status: ${response.statusCode}');
      print('🔸 BedService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success'] == true && responseBody['data'] != null) {
          final data = responseBody['data'] as Map<String, dynamic>;
          if (data['totalBeds'] > 0) {
            return data;
          } else {
            throw Exception('No beds available.');
          }
        } else {
          throw Exception(responseBody['message'] ?? 'Failed to fetch beds: Success was false.');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception('Failed to fetch beds: ${response.statusCode} ${response.body}');
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
