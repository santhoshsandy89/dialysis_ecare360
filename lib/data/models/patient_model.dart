class PatientModel {
  final String mrnNo;
  final String firstName;
  final String lastName;
  final String dob;
  final String bloodType;
  final String phone;
  final String email;

  PatientModel({
    required this.mrnNo,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.bloodType,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'mrnNo': mrnNo,
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'bloodType': bloodType,
        'phone': phone,
        'email': email,
      };

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        mrnNo: json['mrnNo'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        dob: json['dob'],
        bloodType: json['bloodType'],
        phone: json['phone'],
        email: json['email'],
      );
}
