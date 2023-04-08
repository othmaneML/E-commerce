import 'package:dartz/dartz.dart';
import 'package:ecomerce/core/errors/failures.dart';
import 'package:ecomerce/features/auth/domain/repositories/repositories.dart';

import '../../entities/entities.dart';

class SingeInUseCase {
  AuthRepository authRepository;
  SingeInUseCase({required this.authRepository});
  Future<Either<Failure, Unit>> singeIn(String email, String password) async {
    return await authRepository.singeIn(email, password);
  }
}
