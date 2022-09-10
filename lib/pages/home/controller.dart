import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:reactable/reactable.dart';

class HomeController extends BaseController {
  static HomeController get instance => locator<HomeController>();
  final child = Reactable<Child?>(null);

  HomeController();
}
