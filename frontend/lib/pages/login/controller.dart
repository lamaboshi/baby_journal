import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/user.dart';
import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../../services/auth_service.dart';

class LoginController extends BaseController {
  String email = '';
  final formKey = GlobalKey<FormState>();
  final isSignUp = Reactable(false);
  String password = '';
  String userName = '';

  final _authService = locator<AuthService>();

  static LoginController get instance => locator<LoginController>();

  Future login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final user = User(
      name: userName,
      email: email,
      password: password,
      token: 'token',
    );
    final error = isSignUp.value
        ? await _authService.signUp(user)
        : await _authService.login(user);
    if (error == null) {
      return;
    }
    ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(SnackBar(
      content: Text(error),
    ));
  }
}
