import 'package:ecomerce/core/errors/exeptions.dart';
import 'package:ecomerce/core/errors/singe_in_up_exetion.dart';
import 'package:ecomerce/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:ecomerce/features/auth/data/data_source/remote_datasource/firebase_aut.dart';
import 'package:ecomerce/features/auth/domain/entities/entities.dart';

import 'package:ecomerce/core/errors/failures.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/repositories.dart';

class AuthRepositoryImpl extends AuthRepository {
  UserLocalDataSource userLocalDataSource;
  FireBaseAuth fireBaseAuth;
  AuthRepositoryImpl(
      {required this.fireBaseAuth, required this.userLocalDataSource});
  @override
  Future<Either<Failure, Unit>> singeIn(
      String email, String password) async {
    try {
      final response = await fireBaseAuth.singeIn(email, password);
      return const Right(unit);
    } on SignUpOrInWithEmailAndPasswordException catch (e) {
      return Left(AuthWithEmailAndPasswordFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> singeUp(
      String email, String password) async {
    try {
      await fireBaseAuth.singeUp(email, password);
      return const Right(unit);
    } on SignUpOrInWithEmailAndPasswordException catch (e) {
      return Left(AuthWithEmailAndPasswordFailure(e.message));
    } on OfflineException {
      return left(OfflineFailure());
    }
  }

  @override
  Future<void> clearCachedUSer() async {
    await userLocalDataSource.clearCachedUser();
  }

  @override
  Future<bool> getCachedUser() async {
    return await userLocalDataSource.getCachedUser();
  }
}
