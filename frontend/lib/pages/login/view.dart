import 'package:baby_journal/pages/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reactable/reactable.dart';

part 'view.form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginController();
    const style = TextStyle(color: Colors.white, fontSize: 18);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Baby Journal',
              style: TextStyle(
                color: Color(0xff000077),
                fontSize: 32,
              ),
            ),
            Expanded(flex: 4, child: Lottie.asset('assets/baby-loading.json')),
            const _LoginForm(),
            ElevatedButton(
              onPressed: controller.login,
              child: Container(
                color: Colors.lightGreen,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Scope(
                  builder: (_) => Text(
                      controller.isSignUp.value ? 'Sign in' : 'Log in',
                      style: style),
                ),
              ),
            ),
            Scope(
              builder: (_) => Checkbox(
                  value: controller.isSignUp.value,
                  onChanged: (v) => controller.isSignUp.value = v ?? false),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
