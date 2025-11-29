import '../../../../data/models/api_response.dart';
import '../../../../data/models/auth_model.dart';
import '../../../../data/repositories/auth_repository.dart';

/// Login use case
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  /// Execute login with email and password
  Future<ApiResponse<AuthModel>> call({
    required String email,
    required String password,
  }) async {
    return await _authRepository.login(
      email: email,
      password: password,
    );
  }
}
