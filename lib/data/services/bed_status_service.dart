import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecare360/core/utils/logger.dart';
import 'package:ecare360/data/models/bed_status_model.dart';

class BedStatusService {
  static const String _baseUrl = 'https://configurations.dev-hmis.yanthralabs.com/api/v1/status-type';

  Future<List<BedStatusModel>> fetchBedStatuses(String accessToken) async {
    final url = Uri.parse('$_baseUrl?series=200');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);
        AppLogger.debug('Bed statuses fetched successfully.');
        return responseBody.map((json) => BedStatusModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        AppLogger.error('Unauthorized to fetch bed statuses.');
        throw Exception('Unauthorized: Please log in again.');
      } else {
        AppLogger.error('Failed to fetch bed statuses: ${response.statusCode}');
        throw Exception('Failed to fetch bed statuses: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      AppLogger.error('Bed status API call timed out: $e');
      throw Exception('Bed status fetch timed out. Please try again.');
    } catch (e) {
      AppLogger.error('Error fetching bed statuses: $e');
      throw Exception('An unexpected error occurred while fetching bed statuses.');
    }
  }
}
