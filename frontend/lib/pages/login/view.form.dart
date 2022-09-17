part of 'view.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    const inputDecoration = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    );
    final controller = LoginController.instance;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: controller.email,
              onChanged: (value) => controller.email = value,
              onFieldSubmitted: (_) => controller.login(),
              validator: _checkNotEmpty,
              decoration: const InputDecoration(
                label: Text('Email'),
                border: inputDecoration,
              ),
            ),
            Scope(
              builder: (context) => AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInCubic,
                child: controller.isSignUp.value
                    ? TextFormField(
                        initialValue: controller.userName,
                        onChanged: (value) => controller.userName = value,
                        onFieldSubmitted: (_) => controller.login(),
                        validator: _checkNotEmpty,
                        decoration: const InputDecoration(
                          label: Text('User name'),
                          border: inputDecoration,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            TextFormField(
              initialValue: controller.password,
              onChanged: (value) => controller.password = value,
              onFieldSubmitted: (_) => controller.login(),
              validator: _checkNotEmpty,
              decoration: const InputDecoration(
                label: Text('Password'),
                border: inputDecoration,
              ),
              obscureText: true,
            )
          ],
        ),
      ),
    );
  }

  String? _checkNotEmpty(String? value) {
    return value?.isEmpty ?? true ? 'flied required' : null;
  }
}
