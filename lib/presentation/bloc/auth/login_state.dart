part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User? user;
  LoginSuccess(this.user);
}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError(this.errorMessage);
}
