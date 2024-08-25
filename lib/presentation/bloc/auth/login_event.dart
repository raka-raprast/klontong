part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignUpRequested extends LoginEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
}

class LogoutRequested extends LoginEvent {}
