import 'package:ecomerce/features/auth/domain/repositories/repositories.dart';

class GetCashedUserUseCase {
  AuthRepository authRepository;
  GetCashedUserUseCase({required this.authRepository});
  Future<bool> getCachedUser() async {
    return await authRepository.getCachedUser();
  }
}
