import '../../../../data/models/api_response.dart';
import '../../../../data/repositories/auth_repository.dart';

/// Logout use case
class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  /// Execute logout
  Future<ApiResponse<bool>> call() async {
    return await _authRepository.logout();
  }
}
