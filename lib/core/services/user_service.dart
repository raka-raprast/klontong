import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

class UserService {
  User? user;

  Future<void> setUser(User? user) async {
    this.user = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('userId', user.uid);
    } else {
      await prefs.remove('userId');
    }
  }

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      log(userId);
      // Fetch user data from Firebase or other sources if needed
      // For now, we just return a mock user
      return FirebaseAuth.instance.currentUser; // Adjust as needed
    }
    return null;
  }
}

// Register the service
void setupLocator() {
  locator.registerLazySingleton(() => UserService());
}
