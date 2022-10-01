import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

import 'controller.dart';

part 'view.image.dart';
part 'view.info.dart';

class MemoryDetailsView extends StatelessWidget {
  const MemoryDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MemoryDetailsController.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.id != 0 ? 'Edit memory' : 'Add memory'),
        actions: [
          if (MemoryDetailsController.instance.id != 0)
            IconButton(
              onPressed: MemoryDetailsController.instance.delete,
              icon: const Icon(Icons.delete),
            ),
        ],
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
    final controller = MemoryDetailsController.instance;
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
            onPressed: controller.save,
            child: Scope(
              builder: (context) => controller.isWorking.value
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
