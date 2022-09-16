import 'package:baby_journal/pages/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
            ElevatedButton(
              onPressed: controller.login,
              child: Container(
                color: Colors.red,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: const Text('Sign in with Google', style: style),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
