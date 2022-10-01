import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/memory.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/memory/controller.dart';
import 'package:baby_journal/pages/home/memory/widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

class MemoriesView extends StatelessWidget {
  const MemoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = locator<MemoriesController>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Scope(
          builder: (_) => Text('Memories ${controller.count.value}'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (HomeController.instance.child.value == null) return;
              QR.to('/home/memories/0');
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.pageController.refresh(),
        child: SizedBox(
          height: size.height,
          child: PagedListView<int, Memory>(
            pagingController: controller.pageController,
            scrollDirection: Axis.horizontal,
            builderDelegate: PagedChildBuilderDelegate<Memory>(
              itemBuilder: (context, item, index) => SizedBox(
                width: size.width,
                child: MemoryWidget(memory: item),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
