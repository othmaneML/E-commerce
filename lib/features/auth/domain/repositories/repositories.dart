import 'package:dartz/dartz.dart';
import 'package:ecomerce/core/errors/failures.dart';
import 'package:ecomerce/features/auth/domain/entities/entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> singeUp(
      String email, String password);
  Future<Either<Failure, Unit>> singeIn(
      String email, String password);
  Future<bool> getCachedUser();

  Future<void> clearCachedUSer();
}
