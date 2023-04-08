part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class SigningAuthenticationState extends AuthenticationState {}

class TokenValidationExpiredSate extends AuthenticationState {
  final bool isExpired;

  const TokenValidationExpiredSate(this.isExpired);
   @override
  List<Object> get props => [isExpired];
}

class AuthenticationSnackState extends AuthenticationState {
  final String message;
  const AuthenticationSnackState(this.message);
  @override
  List<Object> get props => [message];
}
