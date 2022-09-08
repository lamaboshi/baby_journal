import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/locator.dart';

/// this middleware will add the given controller to the DI when the user enters this page
/// and remove it when the user leaves the page.
class ControllerMid<T extends BaseController> extends QMiddleware {
  ControllerMid(this.loader);

  final T Function() loader;

  @override
  Future onEnter() async {
    final instance = loader();
    await instance.onInit();
    locator.registerSingleton(instance);
  }

  @override
  Future onExit() async {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
  }
}
