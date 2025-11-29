import 'dart:convert';

import 'package:ecare360/data/models/admission_model.dart';
import 'package:http/http.dart' as http;

class AdmissionService {
  static const String _baseUrl =
      "https://patientportal.dev-hmis.yanthralabs.com/api/v1";

  Future<Map<String, dynamic>> createAdmission({
    required AdmissionModel admission,
    required String token,
  }) async {
    final url = Uri.parse("$_baseUrl/admissions");

    final body = jsonEncode(admission.toJson());

    print("🔹 Sending POST: $url");
    print("🔹 Body: $body");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody["success"] == true) {
      return responseBody;
    } else {
      throw Exception(responseBody["message"] ?? "Admission failed");
    }
  }
}
