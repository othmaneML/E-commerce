import 'package:ecomerce/features/auth/domain/repositories/repositories.dart';

class ClearCashedUserUseCase {
  AuthRepository authRepository;
  ClearCashedUserUseCase({required this.authRepository});
  Future<void> clearCachedUser() async {
    return await authRepository.clearCachedUSer();
  }
}
