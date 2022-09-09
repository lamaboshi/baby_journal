import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

class SettingsController extends BaseController {
  static SettingsController get instance => locator<SettingsController>();

  CollectionReference<Map<String, dynamic>> get users =>
      FirebaseFirestore.instance.collection('users');

  final children = ReactableList<Child>([]);

  @override
  Future<void> onInit() async {
    final user = FirebaseAuth.instance.currentUser!;
    final docs = (await users.where('email', isEqualTo: user.email).get()).docs;

    if (docs.isNotEmpty) {
      final info = docs.first.data();
      if (!info.keys.contains('id')) {
        await docs.first.reference.set({
          'email': user.email,
          'id': user.uid,
          'name': user.displayName,
        });
      }
    } else {
      await users.add({
        'email': user.email,
        'id': user.uid,
        'name': user.displayName,
      });
    }

    final dbUser =
        (await users.where('email', isEqualTo: user.email).get()).docs.first;

    users.doc(dbUser.reference.path).snapshots().listen((event) async {
      final childrenRefs = event.data()!['children'] as List<String>;
      children.clear();
      for (var c in childrenRefs) {
        final child = await FirebaseFirestore.instance.doc(c).get();
        children.add(Child.fromMap(child.data()!));
      }
    });
  }

  Future addChild(BuildContext context) async {
    var name = '';
    var birthday = '';
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Add child'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(label: Text('Name')),
              onChanged: (value) => name = value,
            ),
            TextFormField(
              decoration: const InputDecoration(label: Text('Birthday')),
              onChanged: (value) => birthday = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              name = '';
              Navigator.pop(c);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Add'),
          )
        ],
      ),
    );
    if (name.isEmpty || birthday.isEmpty) return;
    if (DateTime.tryParse(birthday) == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Birthday not valid')));
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;
    final ref = await FirebaseFirestore.instance.collection('children').add({
      'name': name,
      'birthday': birthday,
      'parent': [
        user.displayName,
      ]
    });

    final exist = await users.where('email', isEqualTo: user.email).get();
    final info =
        (exist.docs.first.data()['children'] as List<String>?) ?? <String>[];
    info.add(ref.path);
    await exist.docs.first.reference.set({
      'children': info,
    });
  }
}
