import 'base_model.dart';

/// User model representing user data
class UserModel implements BaseModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isActive = false,
    this.role = 'user',
    this.lastLoginAt,
    this.createdAt = '',
    this.updatedAt = '',
  });

  final String id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isActive;
  final String role;
  final String? lastLoginAt;
  final String createdAt;
  final String updatedAt;

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get initials for avatar
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  /// Check if user is verified
  bool get isVerified => isEmailVerified && isPhoneVerified;

  /// Get display name (username or full name)
  String get displayName => username.isNotEmpty ? username : fullName;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
      role: json['role'] as String? ?? 'user',
      lastLoginAt: json['lastLoginAt'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isActive': isActive,
      'role': role,
      'lastLoginAt': lastLoginAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  UserModel copyWith() {
    return UserModel(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      dateOfBirth: dateOfBirth,
      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      isActive: isActive,
      role: role,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.profileImageUrl == profileImageUrl &&
        other.dateOfBirth == dateOfBirth &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.zipCode == zipCode &&
        other.country == country &&
        other.isEmailVerified == isEmailVerified &&
        other.isPhoneVerified == isPhoneVerified &&
        other.isActive == isActive &&
        other.role == role &&
        other.lastLoginAt == lastLoginAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      email,
      username,
      firstName,
      lastName,
      phoneNumber,
      profileImageUrl,
      dateOfBirth,
      address,
      city,
      state,
      zipCode,
      country,
      isEmailVerified,
      isPhoneVerified,
      isActive,
      role,
      lastLoginAt,
      createdAt,
      updatedAt,
    ]);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, profileImageUrl: $profileImageUrl, dateOfBirth: $dateOfBirth, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, isActive: $isActive, role: $role, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
