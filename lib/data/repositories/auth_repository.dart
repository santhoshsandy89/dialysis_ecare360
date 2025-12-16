import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../models/api_response.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

/// Authentication repository for handling auth operations
class AuthRepository {
  final ApiService _apiService;

  AuthRepository({
    required ApiService apiService,
    required LocalStorageService localStorageService,
  }) : _apiService = apiService;

  /// Save authentication tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await LocalStorageService.setString(AppConstants.tokenKey, accessToken);
    await LocalStorageService.setString(
        AppConstants.refreshTokenKey, refreshToken);
    AppLogger.info('Tokens saved successfully.');
  }

  /// Save username and user ID
  Future<void> saveUsernameAndUserId(String username, String userId) async {
    await LocalStorageService.setString(AppConstants.usernameKey, username);
    await LocalStorageService.setString(AppConstants.userIdKey, userId);
    AppLogger.info('Username and User ID saved successfully.');
  }

  /// Get username from local storage
  Future<String?> getUsername() async {
    return await LocalStorageService.getString(AppConstants.usernameKey);
  }

  /// Get user ID from local storage
  Future<String?> getUserId() async {
    return await LocalStorageService.getString(AppConstants.userIdKey);
  }

  /// Get tokenKey from local storage
  Future<String?> getAccessToken() async {
    return await LocalStorageService.getString(AppConstants.tokenKey);
  }

  /// Get refreshTokenKey from local storage
  Future<String?> getRefreshToken() async {
    return await LocalStorageService.getString(AppConstants.refreshTokenKey);
  }

  /// Login with email and password
  Future<ApiResponse<AuthModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting login for email: $email');

      final response = await _apiService.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.isSuccess && response.data != null) {
        final authModel = AuthModel.fromJson(response.data!);

        // Store auth data locally
        await LocalStorageService.setString(
            AppConstants.tokenKey, authModel.accessToken);
        await LocalStorageService.setString(
            AppConstants.userKey, authModel.user.toJson().toString());
        await LocalStorageService.setString(
            AppConstants.refreshTokenKey, authModel.refreshToken);

        // Save username and userId separately
        await saveUsernameAndUserId(authModel.user.username, authModel.user.id);

        AppLogger.info('Login successful for user: ${authModel.user.id}');

        return ApiResponse<AuthModel>(
          success: true,
          message: 'Login successful',
          data: authModel,
          statusCode: response.statusCode,
        );
      } else {
        AppLogger.error('Login failed: ${response.message}');
        return ApiResponse<AuthModel>(
          success: false,
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Login error: $e', e, stackTrace);
      return ApiResponse<AuthModel>(
        success: false,
        message: 'Login failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Register new user
  Future<ApiResponse<AuthModel>> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      AppLogger.info('Attempting registration for email: $email');

      final response = await _apiService.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      );

      if (response.isSuccess && response.data != null) {
        final authModel = AuthModel.fromJson(response.data!);

        // Store auth data locally
        await LocalStorageService.setString(
            AppConstants.tokenKey, authModel.accessToken);
        await LocalStorageService.setString(
            AppConstants.userKey, authModel.user.toJson().toString());

        AppLogger.info(
            'Registration successful for user: ${authModel.user.id}');

        return ApiResponse<AuthModel>(
          success: true,
          message: 'Registration successful',
          data: authModel,
          statusCode: response.statusCode,
        );
      } else {
        AppLogger.error('Registration failed: ${response.message}');
        return ApiResponse<AuthModel>(
          success: false,
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Registration error: $e', e, stackTrace);
      return ApiResponse<AuthModel>(
        success: false,
        message: 'Registration failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Logout user
  Future<ApiResponse<bool>> logout() async {
    try {
      AppLogger.info('Attempting logout');

      // Call logout API
      await _apiService.post('/auth/logout');

      // Clear local storage
      await LocalStorageService.remove(AppConstants.tokenKey);
      await LocalStorageService.remove(AppConstants.userKey);
      await LocalStorageService.remove(AppConstants.usernameKey);
      await LocalStorageService.remove(AppConstants.userIdKey);

      AppLogger.info('Logout successful');

      return const ApiResponse<bool>(
        success: true,
        message: 'Logout successful',
        data: true,
        statusCode: 200,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Logout error: $e', e, stackTrace);

      // Clear local storage even if API call fails
      await LocalStorageService.remove(AppConstants.tokenKey);
      await LocalStorageService.remove(AppConstants.userKey);
      await LocalStorageService.remove(AppConstants.usernameKey);
      await LocalStorageService.remove(AppConstants.userIdKey);

      return const ApiResponse<bool>(
        success: true,
        message: 'Logout successful (local)',
        data: true,
        statusCode: 200,
      );
    }
  }

  /// Get current user from local storage
  Future<ApiResponse<UserModel?>> getCurrentUser() async {
    try {
      print('AuthRepository: Getting current user...');

      // Initialize LocalStorageService if not already initialized
      try {
        await LocalStorageService.init(); // Use the static method here
      } catch (e) {
        print(
            'AuthRepository: LocalStorageService already initialized or error: $e');
      }

      final userData =
          await LocalStorageService.getString(AppConstants.userKey);
      final storedUsername =
          await getUsername(); // Retrieve username from local storage
      final storedUserId =
          await getUserId(); // Retrieve userId from local storage

      print(
          'AuthRepository: User data found: ${userData != null && userData.isNotEmpty}');

      if (userData != null &&
          userData.isNotEmpty &&
          storedUsername != null &&
          storedUserId != null) {
        // Construct UserModel using retrieved data
        final user = UserModel(
            id: storedUserId,
            email: '',
            username: storedUsername,
            firstName: storedUsername,
            lastName: '');
        print('AuthRepository: Returning user data');

        return ApiResponse<UserModel?>(
          success: true,
          message: 'User data retrieved',
          data: user,
          statusCode: 200,
        );
      } else {
        print('AuthRepository: No user data found');
        return const ApiResponse<UserModel?>(
          success: true,
          message: 'No user data found',
          data: null,
          statusCode: 200,
        );
      }
    } catch (e, stackTrace) {
      print('AuthRepository: Error getting current user: $e');
      AppLogger.error('Get current user error: $e', e, stackTrace);
      return ApiResponse<UserModel?>(
        success: false,
        message: 'Failed to get user data: ${e.toString()}',
        data: null,
        statusCode: 500,
      );
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      print('AuthRepository: Checking authentication...');

      // Initialize LocalStorageService if not already initialized
      try {
        await LocalStorageService.init();
      } catch (e) {
        print(
            'AuthRepository: LocalStorageService already initialized or error: $e');
      }

      final token = await LocalStorageService.getString(
          AppConstants.tokenKey); // Use LocalStorageService
      print(
          'AuthRepository: Token found: ${token != null && token.isNotEmpty}');
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('AuthRepository: Error checking authentication: $e');
      AppLogger.error('Authentication check error: $e');
      return false;
    }
  }

  /// Refresh access token
  Future<ApiResponse<AuthModel>> refreshToken() async {
    try {
      final refreshToken = await LocalStorageService.getString(
          'refresh_token'); // Use LocalStorageService

      if (refreshToken == null) {
        return const ApiResponse<AuthModel>(
          success: false,
          message: 'No refresh token available',
          statusCode: 401,
        );
      }

      final response = await _apiService.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.isSuccess && response.data != null) {
        final authModel = AuthModel.fromJson(response.data!);

        // Update stored tokens
        await LocalStorageService.setString(AppConstants.tokenKey,
            authModel.accessToken); // Use LocalStorageService
        await LocalStorageService.setString(AppConstants.refreshTokenKey,
            authModel.refreshToken); // Use LocalStorageService

        return ApiResponse<AuthModel>(
          success: true,
          message: 'Token refreshed successfully',
          data: authModel,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse<AuthModel>(
          success: false,
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Token refresh error: $e', e, stackTrace);
      return ApiResponse<AuthModel>(
        success: false,
        message: 'Token refresh failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
