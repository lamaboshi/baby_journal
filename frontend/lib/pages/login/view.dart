import 'package:baby_journal/pages/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reactable/reactable.dart';

part 'view.form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginController.instance;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Baby Journal',
                style: TextStyle(
                  color: Color(0xff786757),
                  fontSize: 32,
                ),
              ),
              Lottie.asset('assets/baby-login.json'),
              const _LoginForm(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.login,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Scope(
                      builder: (_) => Text(
                        controller.isSignUp.value ? 'Sign Up' : 'Log in',
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Scope(
                    builder: (_) => Switch(
                      value: controller.isSignUp.value,
                      onChanged: (v) => controller.isSignUp.value = v,
                    ),
                  ),
                  const Text(
                    'New user',
                    style: TextStyle(color: Colors.brown),
                  )
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
