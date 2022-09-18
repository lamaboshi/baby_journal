import 'package:baby_journal/pages/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Scope(
          builder: (_) => Text(
            controller.child.value == null
                ? 'Select a child'
                : controller.child.value!.name,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => QR.to('/home/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
