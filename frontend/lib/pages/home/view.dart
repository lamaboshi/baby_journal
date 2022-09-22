import 'package:baby_journal/pages/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby journal'),
        actions: [
          IconButton(
            onPressed: () => QR.to('/home/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scope(
          builder: (_) => controller.child.value == null
              ? const Text('Select a child')
              : const _Body(),
        ),
      ),
      floatingActionButton: controller.child.value == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                QR.to('/home/memories/0');
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    return Column(
      children: [
        Row(
          children: [
            Text(
              controller.child.value!.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Text(
              controller.child.value!.age(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        Lottie.asset('assets/baby-loading.json'),
      ],
    );
  }
}
