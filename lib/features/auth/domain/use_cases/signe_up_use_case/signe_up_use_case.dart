import 'package:dartz/dartz.dart';
import 'package:ecomerce/core/errors/failures.dart';
import 'package:ecomerce/features/auth/domain/repositories/repositories.dart';

import '../../entities/entities.dart';

class SingeUpUseCase {
  AuthRepository authRepository;
  SingeUpUseCase({required this.authRepository});
  Future<Either<Failure, Unit>> singeUp(
      String email, String password) async {
    return await authRepository.singeUp(email, password);
  }
}
