import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlayment/overlayment.dart';
import 'package:reactable/reactable.dart';

import '../../../models/child.dart';

class AddMemoryController extends BaseController {
  static AddMemoryController get instance => locator<AddMemoryController>();
  late final Child child;

  final image = Reactable<XFile?>(null);
  final date = Reactable(DateTime.now());

  @override
  Future<void> onInit() async {
    final path = locator<StorageService>().getString(StorageKeys.childPath)!;
    final dbChild = await FirebaseFirestore.instance.doc(path).get();
    child = Child.fromMap(dbChild.data()!, path);
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
}
