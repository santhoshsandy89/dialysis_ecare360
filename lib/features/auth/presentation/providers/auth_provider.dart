import 'package:ecare360/data/models/auth_model.dart';
import 'package:ecare360/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/services/local_storage_service.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);
  return AuthRepository(
    apiService: apiService,
    localStorageService: localStorageService,
  );
});

/// API service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// Local storage service provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

/// Login use case provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository);
});

/// Logout use case provider
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(authRepository);
});

/// Register use case provider
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(authRepository);
});

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _registerUseCase = registerUseCase,
        _authRepository = authRepository,
        super(const AuthState());

  /// Set access and refresh tokens
  Future<void> setTokens(
    String accessToken,
    String refreshToken,
    String username, // Add username parameter
    String userId, // Add userId parameter
  ) async {
    state = state.copyWith(isLoading: true);

    // Save tokens and user data to local storage
    await _authRepository.saveTokens(accessToken, refreshToken);
    await _authRepository.saveUsernameAndUserId(
        username, userId); // Save username and userId

    AppLogger.debug('AuthNotifier: Setting tokens for user: $username');
    state = state.copyWith(
      authModel: AuthModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 75,
        user: UserModel(
          id: userId,
          firstName: username,
          lastName: '',
          email: '',
          username: username,
        ),
      ),
      isAuthenticated: true,
      isLoading: false,
      errorMessage: null,
    );
  }

  /// Initialize auth state
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    final accessToken =
        await _authRepository.getAccessToken(); // Use new getter
    final refreshToken =
        await _authRepository.getRefreshToken(); // Use new getter
    final storedUsername = await _authRepository.getUsername();
    final storedUserId = await _authRepository.getUserId();

    AppLogger.debug(
        'AuthNotifier: Initializing with stored username: $storedUsername');

    if (accessToken != null && accessToken.isNotEmpty) {
      state = state.copyWith(
        authModel: AuthModel(
          accessToken: accessToken,
          refreshToken: refreshToken ?? '',
          expiresIn: 75,
          user: UserModel(
              id: storedUserId ?? '',
              firstName: storedUsername ?? '',
              lastName: '',
              email: '',
              username: ''),
        ),
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: null,
      );
    }
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final response = await _loginUseCase(
        email: email,
        password: password,
      );

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          authModel: response.data,
          errorMessage: null,
        );
        AppLogger.info('Login successful for user: ${response.data!.user.id}');
      } else {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: response.message,
        );
        AppLogger.error('Login failed: ${response.message}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Login error: $e', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'Login failed: ${e.toString()}',
      );
    }
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final response = await _registerUseCase(
        email: email,
        password: password,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          authModel: response.data,
          errorMessage: null,
        );
        AppLogger.info(
            'Registration successful for user: ${response.data!.user.id}');
      } else {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: response.message,
        );
        AppLogger.error('Registration failed: ${response.message}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Registration error: $e', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: 'Registration failed: ${e.toString()}',
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final response = await _logoutUseCase();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        authModel: null,
        errorMessage: response.isSuccess ? null : response.message,
      );

      if (response.isSuccess) {
        AppLogger.info('Logout successful');
      } else {
        AppLogger.error('Logout failed: ${response.message}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Logout error: $e', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        authModel: null,
        errorMessage: 'Logout failed: ${e.toString()}',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Refresh authentication
  Future<void> refreshAuth() async {
    await initialize();
  }

  // Method to set loading
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  // Optionally, method to set error
  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }
}

/// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  final registerUseCase = ref.watch(registerUseCaseProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
    registerUseCase: registerUseCase,
    authRepository: authRepository,
  );
});
