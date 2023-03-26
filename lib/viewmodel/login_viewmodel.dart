
import 'package:flutter/material.dart';
import 'package:flutterapidemo/service/bipower_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class LoginViewModel extends ChangeNotifier {

  final BuildContext context;

  LoginViewModel({required this.context});

  bool isLoading = false;
  String? error;
  User? user;

  bool get isLoginError => error != null;

  NetworkService get networkService => NetworkService.instance;

  Future<User?> login(String username, String password) async {
    isLoading = true;
    notifyListeners();
    final result = await networkService.login(username, password);

    if (result.isSuccess) {
      user = result.value!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', user?.jwtToken ?? "");
      error = null;
    } else {
      error = result.error ?? "Có lỗi xảy ra!";
    }

    isLoading = false;
    notifyListeners();

    return user;
  }
}