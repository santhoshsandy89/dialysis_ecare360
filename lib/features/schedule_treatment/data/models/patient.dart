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

extension BloodTypeExtension on BloodType {
  String get displayName {
    switch (this) {
      case BloodType.APositive:
        return 'A+';
      case BloodType.ANegative:
        return 'A-';
      case BloodType.BPositive:
        return 'B+';
      case BloodType.BNegative:
        return 'B-';
      case BloodType.ABPositive:
        return 'AB+';
      case BloodType.ABNegative:
        return 'AB-';
      case BloodType.OPositive:
        return 'O+';
      case BloodType.ONegative:
        return 'O-';
    }
  }
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
