import 'base_model.dart';
import 'user_model.dart';

/// Authentication model containing user and token information
class AuthModel implements BaseModel {
  const AuthModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType = 'Bearer',
    this.createdAt = '',
  });

  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final String createdAt;

  /// Check if token is expired
  bool get isTokenExpired {
    final now = DateTime.now().millisecondsSinceEpoch;
    final tokenCreatedAt = DateTime.tryParse(createdAt)?.millisecondsSinceEpoch ?? 0;
    return (now - tokenCreatedAt) > (expiresIn * 1000);
  }

  /// Get authorization header value
  String get authorizationHeader => '$tokenType $accessToken';

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'tokenType': tokenType,
      'createdAt': createdAt,
    };
  }

  @override
  AuthModel copyWith() {
    return AuthModel(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      tokenType: tokenType,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthModel &&
        other.user == user &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.expiresIn == expiresIn &&
        other.tokenType == tokenType &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(user, accessToken, refreshToken, expiresIn, tokenType, createdAt);
  }

  @override
  String toString() {
    return 'AuthModel(user: $user, accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, tokenType: $tokenType, createdAt: $createdAt)';
  }
}
