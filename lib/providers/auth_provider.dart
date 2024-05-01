import 'package:flutter/material.dart';
import 'package:dream_sauna/models/user_model.dart';
import 'package:dream_sauna/services/service.dart';


class AuthProvider with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }


  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = await UserService().login(
        email: email,
        password: password,
      );

      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
