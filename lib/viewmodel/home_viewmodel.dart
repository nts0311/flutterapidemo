
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/bipower_service.dart';

class HomeViewModel extends ChangeNotifier {

  NetworkService get networkService => NetworkService.instance;

  bool isLoading = false;
  String? error;

  Future<bool> logout() async {
    final result = await networkService.logout();

    isLoading = true;
    notifyListeners();

    if (result.isSuccess) {
      error = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt');
    } else {
      error = result.error ?? "Có lỗi xảy ra!";
    }

    isLoading = false;
    notifyListeners();

    return error == null;
  }
}