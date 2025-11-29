import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../models/api_response.dart';

/// API service for handling HTTP requests
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${AppConstants.baseUrl}${AppConstants.apiVersion}',
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        sendTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// GET request
  Future<ApiResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      AppLogger.info('GET request to: $path');
      
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e, stackTrace) {
      AppLogger.error('GET request error: $e', e, stackTrace);
      return ApiResponse<dynamic>(
        success: false,
        message: 'Request failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// POST request
  Future<ApiResponse<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      AppLogger.info('POST request to: $path');
      
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e, stackTrace) {
      AppLogger.error('POST request error: $e', e, stackTrace);
      return ApiResponse<dynamic>(
        success: false,
        message: 'Request failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// PUT request
  Future<ApiResponse<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      AppLogger.info('PUT request to: $path');
      
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e, stackTrace) {
      AppLogger.error('PUT request error: $e', e, stackTrace);
      return ApiResponse<dynamic>(
        success: false,
        message: 'Request failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// DELETE request
  Future<ApiResponse<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      AppLogger.info('DELETE request to: $path');
      
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e, stackTrace) {
      AppLogger.error('DELETE request error: $e', e, stackTrace);
      return ApiResponse<dynamic>(
        success: false,
        message: 'Request failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Handle successful response
  ApiResponse<dynamic> _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 200;
    final isSuccess = statusCode >= 200 && statusCode < 300;

    return ApiResponse<dynamic>(
      success: isSuccess,
      message: isSuccess ? 'Request successful' : 'Request failed',
      data: response.data,
      statusCode: statusCode,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  /// Handle Dio errors
  ApiResponse<dynamic> _handleDioError(DioException error) {
    String message = 'Request failed';
    int statusCode = 500;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        statusCode = 408;
        break;
      case DioExceptionType.badResponse:
        statusCode = error.response?.statusCode ?? 500;
        message = _extractErrorMessage(error.response?.data) ?? 'Server error';
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        statusCode = 499;
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error. Please check your internet connection.';
        statusCode = 0;
        break;
      case DioExceptionType.badCertificate:
        message = 'Certificate error';
        statusCode = 495;
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          message = 'No internet connection';
          statusCode = 0;
        } else {
          message = 'Unknown error occurred';
          statusCode = 500;
        }
        break;
    }

    AppLogger.error('Dio error: $message', error);

    return ApiResponse<dynamic>(
      success: false,
      message: message,
      statusCode: statusCode,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? data['detail'];
    }
    
    if (data is String) {
      try {
        final jsonData = jsonDecode(data);
        if (jsonData is Map<String, dynamic>) {
          return jsonData['message'] ?? jsonData['error'] ?? jsonData['detail'];
        }
      } catch (e) {
        return data;
      }
    }
    
    return data.toString();
  }
}

/// Auth interceptor for adding authentication headers
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // This would typically get the token from a secure storage service
    // For now, we'll skip this in the interceptor
    handler.next(options);
  }
}

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.debug('Request: ${options.method} ${options.uri}');
      if (options.data != null) {
        AppLogger.debug('Request data: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.debug('Response: ${response.statusCode} ${response.requestOptions.uri}');
      AppLogger.debug('Response data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.error('Dio error: ${err.message}');
    }
    handler.next(err);
  }
}

/// Error interceptor for handling common errors
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific error cases here
    // For example, token expiration, network issues, etc.
    handler.next(err);
  }
}
