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
    const style = TextStyle(color: Colors.white, fontSize: 18);
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
                  color: Color(0xff000077),
                  fontSize: 32,
                ),
              ),
              Lottie.asset('assets/baby-loading.json'),
              const _LoginForm(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
                ),
                onPressed: controller.login,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Scope(
                      builder: (_) => Text(
                          controller.isSignUp.value ? 'Sign Up' : 'Log in',
                          style: style),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Scope(
                    builder: (_) => Checkbox(
                        value: controller.isSignUp.value,
                        onChanged: (v) =>
                            controller.isSignUp.value = v ?? false),
                  ),
                  const Text('New user')
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
