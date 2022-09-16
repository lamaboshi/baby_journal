import 'dart:io';

import 'package:baby_journal/pages/memory/add/controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

part 'view.image.dart';
part 'view.info.dart';

class AddMemoryView extends StatelessWidget {
  const AddMemoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add memory'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _ImageSection(),
            SizedBox(height: 8),
            _InfoSection(),
            SizedBox(height: 16),
            _ActionsSection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: QR.back,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: AddMemoryController.instance.save,
            child: Scope(
              builder: (context) => AddMemoryController.instance.isWorking.value
                  ? const CircularProgressIndicator()
                  : const Text('Add'),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
