import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import 'package:ecomerce/core/resources/routes_manager.dart';
import 'package:ecomerce/core/snack_bar/snack_bar.dart';
import 'package:ecomerce/features/auth/data/data_source/remote_datasource/firebase_aut.dart';
import 'package:ecomerce/features/auth/domain/entities/entities.dart';
import 'package:ecomerce/features/auth/domain/use_cases/clear_cached_cser/clear_cached_user.dart';
import 'package:ecomerce/features/auth/domain/use_cases/get_cached_cser/get_cached_user.dart';
import 'package:ecomerce/features/auth/domain/use_cases/signe_in_Use_case/signe_in_use_case.dart';
import 'package:ecomerce/features/auth/domain/use_cases/signe_up_use_case/signe_up_use_case.dart';
import 'package:ecomerce/features/carts/domain/usecases/get_products.dart';
import 'package:ecomerce/features/products/presentation/bloc/products_block/products_block_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  ProductsBloc productsBloc;
  SingeInUseCase singeInUseCase;
  SingeUpUseCase singeUpUseCase;
  GetCashedUserUseCase getCashedUserUseCase;

  ClearCashedUserUseCase clearCashedUserUseCase;
  User user = User();
  Timer? _autoTimer;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthenticationCubit({
    required this.clearCashedUserUseCase,
    required this.getCashedUserUseCase,
    required this.navigatorKey,
    required this.productsBloc,
    required this.singeInUseCase,
    required this.singeUpUseCase,
  }) : super(AuthenticationInitial());

  void singeIn(String email, String password) async {
    emit(SigningAuthenticationState());
    final response = await singeInUseCase.singeIn(email, password);
    emit(responseMethod(response));
  }

  Future<void> singeUp(String email, String password) async {
    emit(SigningAuthenticationState());
    final response = await singeUpUseCase.singeUp(email, password);
    emit(responseMethod(response));
  }

  Future<void> getCashedUser() async {
    final response = await getCashedUserUseCase.getCachedUser();
    if (response) {
      if (DateTime.now().isAfter(DateTime.parse(user.expiresIn))) {
        navigatorKey.currentState?.pushReplacementNamed(Routes.authentication);
      } else {
        productsBloc.add(FetchAllProductsEvent());
        navigatorKey.currentState
            ?.pushReplacementNamed(Routes.productOverViewRoute);
      }
    } else {
      navigatorKey.currentState?.pushReplacementNamed(Routes.authentication);
    }
  }

  void autoLogout() {
    _autoTimer != null ? _autoTimer!.cancel() : null;

    final timeToExpire =
        DateTime.parse(user.expiresIn).difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

  void logout() {
    clearCashedUserUseCase.clearCachedUser();
    _autoTimer?.cancel();
    user
      ..expiresIn = "0000-00-00"
      ..idToken = ''
      ..localId = '';
    navigatorKey.currentState?.pushReplacementNamed(Routes.authentication);
  }

  AuthenticationState responseMethod(
      Either<Failure, Unit> response) {
    return response.fold((l) {
      return AuthenticationSnackState((l as AuthWithEmailAndPasswordFailure).message);
    }, (r) {
      autoLogout();
      productsBloc.add(FetchAllProductsEvent());
      navigatorKey.currentState
          ?.pushReplacementNamed(Routes.productOverViewRoute);
      return const TokenValidationExpiredSate(false);
    });
  }
}
