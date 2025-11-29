/// Generic API response wrapper
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode = 200,
    this.timestamp = '',
  });

  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int statusCode;
  final String timestamp;

  /// Check if response is successful
  bool get isSuccess => success && statusCode >= 200 && statusCode < 300;

  /// Check if response has data
  bool get hasData => data != null;

  /// Get error message from errors map
  String? get firstError {
    if (errors == null || errors!.isEmpty) return null;
    final firstKey = errors!.keys.first;
    final firstValue = errors![firstKey];
    if (firstValue is List && firstValue.isNotEmpty) {
      return firstValue.first.toString();
    }
    return firstValue?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
      'statusCode': statusCode,
      'timestamp': timestamp,
    };
  }

  ApiResponse<T> copyWith({
    bool? success,
    String? message,
    T? data,
    Map<String, dynamic>? errors,
    int? statusCode,
    String? timestamp,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      errors: errors ?? this.errors,
      statusCode: statusCode ?? this.statusCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponse<T> &&
        other.success == success &&
        other.message == message &&
        other.data == data &&
        other.errors == errors &&
        other.statusCode == statusCode &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(success, message, data, errors, statusCode, timestamp);
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data, errors: $errors, statusCode: $statusCode, timestamp: $timestamp)';
  }
}

/// API error response
class ApiError {
  const ApiError({
    required this.message,
    this.statusCode = 500,
    this.details,
    this.timestamp = '',
  });

  final String message;
  final int statusCode;
  final Map<String, dynamic>? details;
  final String timestamp;

  /// Create API error from exception
  factory ApiError.fromException(dynamic exception) {
    return ApiError(
      message: exception.toString(),
      statusCode: 500,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'details': details,
      'timestamp': timestamp,
    };
  }

  ApiError copyWith({
    String? message,
    int? statusCode,
    Map<String, dynamic>? details,
    String? timestamp,
  }) {
    return ApiError(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiError &&
        other.message == message &&
        other.statusCode == statusCode &&
        other.details == details &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(message, statusCode, details, timestamp);
  }

  @override
  String toString() {
    return 'ApiError(message: $message, statusCode: $statusCode, details: $details, timestamp: $timestamp)';
  }
}
