import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/memory.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/memory/controller.dart';
import 'package:baby_journal/pages/home/memory/widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qlevar_router/qlevar_router.dart';

class MemoriesView extends StatelessWidget {
  const MemoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = locator<MemoriesController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories'),
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
        child: PagedListView<int, Memory>(
          pagingController: controller.pageController,
          builderDelegate: PagedChildBuilderDelegate<Memory>(
            itemBuilder: (context, item, index) => MemoryWidget(memory: item),
          ),
        ),
      ),
    );
  }
}
