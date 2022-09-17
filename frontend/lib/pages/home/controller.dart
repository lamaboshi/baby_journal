import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:overlayment/overlayment.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

import '../../services/storage_service.dart';

class HomeController extends BaseController {
  static HomeController get instance => locator<HomeController>();
  final child = Reactable<Child?>(null);

  @override
  Future<void> onInit() async {
    final path = locator<StorageService>().getString(StorageKeys.selectedChild);
  }

  void addMemory() {
    if (child.value == null) {
      Overlayment.showMessage('Please select a child');
      return;
    }
    QR.to('/memory/add');
  }
}
