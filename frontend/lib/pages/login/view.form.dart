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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.white12,
            blurRadius: 8,
            spreadRadius: 5,
          )
        ],
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: controller.userName,
                onChanged: (value) => controller.userName = value,
                onFieldSubmitted: (_) => controller.login(),
                validator: _checkNotEmpty,
                decoration: const InputDecoration(
                  label: Text('User name'),
                  border: inputDecoration,
                ),
              ),
              Scope(
                builder: (context) => AnimatedSize(
                  duration: const Duration(seconds: 1),
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
      ),
    );
  }

  String? _checkNotEmpty(String? value) {
    return value?.isEmpty ?? true ? 'flied required' : null;
  }
}
