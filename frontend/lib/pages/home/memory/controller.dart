import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:baby_journal/models/memory.dart';
import 'package:baby_journal/pages/home/memory/service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:reactable/reactable.dart';

import '../controller.dart';

class MemoriesController extends BaseController {
  final pageController = PagingController<int, Memory>(firstPageKey: 0);
  late final Child child;
  final _service = locator<MemoriesService>();
  final _pageSize = 25;
  final count = Reactable(0);

  @override
  Future<void> onInit() {
    child = HomeController.instance.child.value!;
    pageController.addPageRequestListener(_updatePage);
    return super.onInit();
  }

  Future _updatePage(int pageKey) async {
    try {
      final newItems = await _service.getAll(
        child.id,
        pageKey * _pageSize,
        _pageSize,
      );
      pageKey++;
      final isLastPage = newItems!.count < pageKey * _pageSize;
      if (count.value != newItems.count) {
        count(newItems.count);
      }
      if (isLastPage) {
        pageController.appendLastPage(newItems.records);
      } else {
        pageController.appendPage(newItems.records, pageKey);
      }
    } catch (error) {
      pageController.error = error;
    }
  }

  @override
  Future<void> onExit() {
    pageController.dispose();
    return super.onExit();
  }
}
