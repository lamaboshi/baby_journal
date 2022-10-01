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

class MemoryDetailsController extends BaseController {
  late final Child child;
  final date = Reactable(DateTime.now());
  final id = QR.params['id']?.asInt ?? 0;
  final image = Reactable<XFile?>(null);
  final isWorking = Reactable(false);
  final length = Reactable(0.0);
  String? networkImage;
  final text = Reactable('');
  final title = Reactable('');
  final weight = Reactable(0.0);

  final _service = locator<MemoriesService>();

  @override
  Future<void> onInit() async {
    child = HomeController.instance.child.value!;
    if (id == 0) return;
    final value = await _service.get(id);
    networkImage = value.image;
    date(value.at);
    length(value.length);
    weight(value.weight);
    title(value.title);
    text(value.text);
  }

  static MemoryDetailsController get instance =>
      locator<MemoryDetailsController>();

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    image.value = await picker.pickImage(source: source);
  }

  void changeDate() {
    showDatePicker(
      context: Overlayment.navigationKey!.currentContext!,
      initialDate: date.read,
      firstDate: child.birthday.subtract(const Duration(days: 30)),
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

    if (networkImage == null && image.read == null) {
      Overlayment.showMessage('Image must be added');
      return;
    }
    isWorking.value = true;
    try {
      final imageUrl = networkImage ?? await _uploadImage();
      final memory = Memory(
        id: id,
        at: date.value,
        createdAt: DateTime.now().toUtc(),
        image: imageUrl,
        childId: child.id,
        length: length.read,
        text: text.read,
        title: title.read,
        weight: weight.read,
      );
      if (id == 0) {
        await _service.add(memory);
      } else {
        await _service.edit(memory);
      }
      await QR.back();
    } catch (e, s) {
      log(s.toString());
      Overlayment.showMessage('Error saving data');
      isWorking.value = false;
    }
  }

  Future<String> _uploadImage() async {
    return _service.addImage(child.id, image.value!);
  }

  Future delete() async {
    await _service.delete(id);
    QR.back();
  }
}
