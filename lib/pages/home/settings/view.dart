import 'package:baby_journal/pages/home/settings/controller.dart';
import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return Column(
      children: [
        const SizedBox(height: kToolbarHeight),
        Card(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    'Children',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => controller.addChild(context),
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              Scope(
                builder: (_) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.children.length,
                  itemBuilder: (context, index) {
                    return Text(controller.children[index].name);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
