import 'dart:io';

import 'package:baby_journal/pages/memory/add/controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reactable/reactable.dart';

part 'view.image.dart';

class AddMemoryView extends StatelessWidget {
  const AddMemoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add memory'),
      ),
      body: Column(
        children: const [
          Expanded(flex: 3, child: _ImageSection()),
          SizedBox(height: 8),
          Expanded(flex: 4, child: _InfoSection()),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _AgeSection(),
      ],
    );
  }
}

class _AgeSection extends StatelessWidget {
  const _AgeSection();

  @override
  Widget build(BuildContext context) {
    final controller = AddMemoryController.instance;
    final formatter = DateFormat.yMMMd();
    return InkWell(
      onTap: controller.changeDate,
      child: Scope(
        builder: (_) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 8),
            Text(
              formatter.format(controller.date.value),
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(width: 8),
            Text(controller.child.age(today: controller.date.value)),
          ],
        ),
      ),
    );
  }
}
