import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:baby_journal/models/user.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/settings/service.dart';
import 'package:baby_journal/services/storage_service.dart';
import 'package:baby_journal/widgets/inputs_panel.dart';
import 'package:overlayment/overlayment.dart';
import 'package:reactable/reactable.dart';

class SettingsController extends BaseController {
  static SettingsController get instance => locator<SettingsController>();

  final children = ReactableList<Child>([]);
  final _service = locator<SettingsService>();
  @override
  Future<void> onInit() async {
    updateChildren();
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
    final date = DateTime.tryParse('$birthday 00:00:00');
    if (date == null) {
      Overlayment.showMessage('Birthday not valid');
      return;
    }
    final child = await _service.add(name, date);
    if (child != null) {
      children.add(child);
    }
  }

  Future delete(Child child) async {
    final result =
        await OverWindow.simple(message: 'Are you sure?').show<bool?>();
    if (result != true) return;

    if (await _service.delete(child.id)) {
      children.remove(child);
    }
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
    final selectedChild = HomeController.instance.child;
    final child = await _service.addParent(selectedChild.value!.id, email);
    if (child != null) {
      selectedChild(child);
    }
  }

  Future removeParent(User user) async {
    final result =
        await OverWindow.simple(message: 'remove ${user.name} as parent?')
            .show<bool?>();
    if (result != true) return;

    final selectedChild = HomeController.instance.child;
    final child = await _service.addParent(selectedChild.value!.id, user.email);
    if (child != null) {
      selectedChild(child);
    }
  }

  void setChild(Child child) {
    HomeController.instance.child.value = child;
    locator<StorageService>().setInt(StorageKeys.selectedChild, child.id);
  }

  void updateChildren() {
    _service.getChildren().then((value) {
      if (value != null) {
        children.value = value;
      }
    });
  }

  Future update(String name, String birthday) async {
    if (name.isEmpty || birthday.isEmpty) return;
    final date = DateTime.tryParse('$birthday 00:00:00');
    if (date == null) {
      Overlayment.showMessage('Birthday not valid');
      return;
    }
    final controller = HomeController.instance;
    final child = await _service.edit(controller.child.value!.id, name, date);
    if (child == null) return;
    children.removeWhere((element) => element.id == child.id);
    children.add(child);
    controller.child.value = child;
  }
}
