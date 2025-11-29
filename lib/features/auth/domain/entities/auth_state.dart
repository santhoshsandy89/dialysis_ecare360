import '../../../../data/models/auth_model.dart';

/// Authentication state for the app
class AuthState {
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.authModel,
    this.errorMessage,
    this.isInitialized = false,
  });

  final bool isLoading;
  final bool isAuthenticated;
  final AuthModel? authModel;
  final String? errorMessage;
  final bool isInitialized;

  /// Check if user is logged in
  bool get isLoggedIn => isAuthenticated && authModel != null;

  /// Get current user
  String? get currentUserId => authModel?.user.id;

  /// Get access token
  String? get accessToken => authModel?.accessToken;

  /// Check if there's an error
  bool get hasError => errorMessage != null;

  /// Check if loading
  bool get isIdle => !isLoading && !isAuthenticated && !hasError;

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    AuthModel? authModel,
    String? errorMessage,
    bool? isInitialized,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      authModel: authModel ?? this.authModel,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.isLoading == isLoading &&
        other.isAuthenticated == isAuthenticated &&
        other.authModel == authModel &&
        other.errorMessage == errorMessage &&
        other.isInitialized == isInitialized;
  }

  @override
  int get hashCode {
    return Object.hash(isLoading, isAuthenticated, authModel, errorMessage, isInitialized);
  }

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, isAuthenticated: $isAuthenticated, authModel: $authModel, errorMessage: $errorMessage, isInitialized: $isInitialized)';
  }
}
