enum BloodType {
  APositive,
  ANegative,
  BPositive,
  BNegative,
  ABPositive,
  ABNegative,
  OPositive,
  ONegative
}

class Patient {
  final String mrnNo;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final BloodType bloodType;
  final String phone;
  final String email;

  Patient({
    required this.mrnNo,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.bloodType,
    required this.phone,
    required this.email,
  });

  String get fullName => '${firstName} ${lastName}';
}
