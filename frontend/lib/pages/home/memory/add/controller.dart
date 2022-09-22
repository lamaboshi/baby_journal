import 'dart:developer';

import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/memory.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/memory/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlayment/overlayment.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

import '../../../../models/child.dart';
import 'memory_saved_widget.dart';

class MemoryDetailsController extends BaseController {
  static MemoryDetailsController get instance =>
      locator<MemoryDetailsController>();
  late final Child child;

  final image = Reactable<XFile?>(null);
  final date = Reactable(DateTime.now());
  final length = Reactable(0.0);
  final weight = Reactable(0.0);
  final title = Reactable('');
  final text = Reactable('');
  final isWorking = Reactable(false);
  final _service = locator<MemoriesService>();
  @override
  Future<void> onInit() async {
    child = HomeController.instance.child.value!;
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    image.value = await picker.pickImage(source: source);
  }

  void changeDate() {
    showDatePicker(
      context: Overlayment.navigationKey!.currentContext!,
      initialDate: date.read,
      firstDate: child.birthday,
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      date.value = value;
    });
  }

  Future save() async {
    if (isWorking.value) return;

    if (image.read == null) {
      Overlayment.showMessage('Image must be added');
      return;
    }
    isWorking.value = true;
    try {
      final imageUrl = await _uploadImage();
      final memory = Memory(
        id: 0,
        at: date.value,
        createdAt: DateTime.now().toUtc(),
        image: imageUrl,
        childId: child.id,
        length: length.read,
        text: text.read,
        title: title.read,
        weight: weight.read,
      );
      await _service.add(memory);
      await Overlayment.show(OverDialog(
        child: const MemorySavedWidget(),
        duration: const Duration(seconds: 3),
      ));

      await QR.back();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      Overlayment.showMessage('Error saving data');
      isWorking.value = false;
    }
  }

  Future<String> _uploadImage() async {
    return _service.addImage(child.id, image.value!);
  }
}
