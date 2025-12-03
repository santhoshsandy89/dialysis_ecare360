class PatientIDModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String username; // Added username field

  PatientIDModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username, // Initialize username
  });

  factory PatientIDModel.fromJson(Map<String, dynamic> json) {
    return PatientIDModel(
      id: json['userid']?.toString() ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      username: json['username'] as String? ?? '', // Parse username
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'username': username, // Serialize username
    };
  }
}
