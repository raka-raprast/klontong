import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/data/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
          event.email, event.password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
          event.email, event.password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<LoginState> emit) async {
    try {
      await _authRepository.signOut();
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<String?> getToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      return user?.getIdToken();
    } catch (e) {
      print("Error fetching token: $e");
      return null;
    }
  }
}
