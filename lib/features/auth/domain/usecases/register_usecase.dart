import '../../../../data/models/api_response.dart';
import '../../../../data/models/auth_model.dart';
import '../../../../data/repositories/auth_repository.dart';

/// Register use case
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  /// Execute registration
  Future<ApiResponse<AuthModel>> call({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    return await _authRepository.register(
      email: email,
      password: password,
      username: username,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }
}
