import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/services/user_service.dart';
import 'package:klontong/data/repositories/authentication_repository.dart';
import 'package:klontong/presentation/auth/login_screen.dart';
import 'package:klontong/presentation/bloc/auth/login_bloc.dart';

import 'base_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final IAuthRepository authRepository = AuthRepository(FirebaseAuth.instance);
  setupLocator();
  runApp(App(authRepository: authRepository));
}

class App extends StatelessWidget {
  final IAuthRepository authRepository;

  const App({Key? key, required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authRepository),
      child: MaterialApp(
        title: 'Flutter Firebase Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(authRepository: authRepository),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  final IAuthRepository authRepository;

  const SplashScreen({Key? key, required this.authRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return FutureBuilder(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              if (snapshot.hasData) {
                return BaseTabScreen(
                  loginBloc: BlocProvider.of<LoginBloc>(context),
                );
              } else {
                return LoginPage(); // Navigate to LoginPage if not authenticated
              }
            }
          },
        );
      },
    );
  }
}
