import 'dart:developer';

import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/memory.dart';
import 'package:baby_journal/pages/memory/add/memory_saved_widget.dart';
import 'package:baby_journal/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlayment/overlayment.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';
import 'package:uuid/uuid.dart';

import '../../../models/child.dart';

class AddMemoryController extends BaseController {
  static AddMemoryController get instance => locator<AddMemoryController>();
  late final Child child;

  final image = Reactable<XFile?>(null);
  final date = Reactable(DateTime.now());
  final length = Reactable(0.0);
  final weight = Reactable(0.0);
  final title = Reactable('');
  final text = Reactable('');
  final isWorking = Reactable(false);

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

  Future save() async {
    if (isWorking.value) return;
    isWorking.value = true;

    if (image.read == null) {
      Overlayment.showMessage('Image must be added');
      return;
    }
    try {
      final store = FirebaseFirestore.instance.collection('memories');
      final imageUrl = await _uploadImage();
      final memory = Memory(
        at: date.value,
        createdAt: DateTime.now().toUtc(),
        createdFrom: FirebaseAuth.instance.currentUser!.displayName!,
        image: imageUrl,
        child: child.id,
        length: length.read,
        text: text.read,
        title: title.read,
        weight: weight.read,
      );
      final dbMemory = await store.add(memory.toMap());
      await FirebaseFirestore.instance.doc(child.id).update({
        'memories': FieldValue.arrayUnion([dbMemory.path])
      });

      await Overlayment.show(OverDialog(
        child: const MemorySavedWidget(),
        duration: const Duration(seconds: 2),
      ));

      isWorking.value = false;
      QR.back();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      Overlayment.showMessage('Error saving data');
      isWorking.value = false;
    }
  }

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance.ref();
    final refName =
        child.id + const Uuid().v4() + image.read!.name.split('.')[1];
    final ref = storage.child(refName);
    final bytes = await image.read!.readAsBytes();
    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }
}
