import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/services/storage_service.dart';
import 'package:baby_journal/widgets/inputs_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlayment/overlayment.dart';
import 'package:reactable/reactable.dart';

class SettingsController extends BaseController {
  static SettingsController get instance => locator<SettingsController>();

  FirebaseFirestore get store => FirebaseFirestore.instance;
  late final String userPath;
  CollectionReference<Map<String, dynamic>> get users =>
      store.collection('users');

  final children = ReactableList<Child>([]);

  @override
  Future<void> onInit() async {
    userPath = await _getUser();

    store.doc(userPath).snapshots().listen((event) async {
      final childrenRefs =
          (event.data()!['children'] as List<dynamic>?) ?? <dynamic>[];
      children.clear();
      for (var c in childrenRefs) {
        final child = await FirebaseFirestore.instance.doc(c).get();
        children.add(Child.fromMap(child.data()!, c.toString()));
      }
    });
  }

  Future<String> _getUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final docs = (await users.where('email', isEqualTo: user.email).get()).docs;

    if (docs.isNotEmpty) {
      final info = docs.first.data();
      if (!info.keys.contains('id')) {
        await docs.first.reference.update({
          'email': user.email,
          'id': user.uid,
          'name': user.displayName,
        });
        final dbChildren = info['children'] as List<dynamic>;
        for (var child in dbChildren) {
          await store.doc(child).update({
            'family': FieldValue.arrayUnion([user.displayName])
          });
        }
      }
      return docs.first.reference.path;
    } else {
      final ref = await users.add({
        'email': user.email,
        'id': user.uid,
        'name': user.displayName,
      });
      return ref.path;
    }
  }

  Future addChild() async {
    var name = '';
    var birthday = '';
    await OverPanel(
      child: InputsPanel(
        label1: 'Name',
        param1: (v) => name = v,
        label2: 'Birthday',
        param2: (v) => birthday = v,
      ),
    ).show();

    if (name.isEmpty || birthday.isEmpty) return;
    if (DateTime.tryParse('$birthday 00:00:00') == null) {
      Overlayment.showMessage('Birthday not valid');
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;
    final ref = await FirebaseFirestore.instance.collection('children').add({
      'name': name,
      'birthday': birthday,
      'family': [
        user.displayName,
      ]
    });

    final exist = await users.where('email', isEqualTo: user.email).get();
    await exist.docs.first.reference.update({
      'children': FieldValue.arrayUnion([ref.path]),
    });
  }

  Future delete(Child child) async {
    final result =
        await OverWindow.simple(message: 'Are you sure?').show<bool?>();
    if (result != true) return;

    store.doc(userPath).update({
      'children': FieldValue.arrayRemove([child.id])
    });
    final dbChild = await store.doc(userPath).get();
    final family = dbChild.data()!['children'] as List<dynamic>;
    if (family.isEmpty) await store.doc(child.id).delete();
  }

  Future addParent() async {
    var email = '';
    await OverPanel(
      child: InputsPanel(
        label1: 'Parent email',
        param1: (v) => email = v,
      ),
    ).show();
    if (email.isEmpty) return;
    final childId = HomeController.instance.child.value!.id;
    final docs = (await users.where('email', isEqualTo: email).get()).docs;
    var parentPath = '';
    if (docs.isNotEmpty) {
      parentPath = docs.first.reference.path;
      store.doc(parentPath).update({
        'children': FieldValue.arrayUnion([childId])
      });
    } else {
      final ref = await users.add({
        'email': email,
        'children': [childId],
      });
      parentPath = ref.path;
    }
  }

  void setChild(Child child) {
    HomeController.instance.child.value = child;
    locator<StorageService>().setString(StorageKeys.childPath, child.id);
  }
}
