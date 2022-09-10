import 'package:baby_journal/models/child.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/settings/controller.dart';
import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const [
          _ChildrenWidget(),
          Divider(),
          _ParentsWidget(),
          Divider(),
          _ChildInfoWidget(),
          Divider(),
        ],
      ),
    );
  }
}

class _ChildrenWidget extends StatelessWidget {
  const _ChildrenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            Text(
              'Children',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            IconButton(
              onPressed: controller.addChild,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Scope(
            builder: (_) => ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: controller.children.length,
              itemBuilder: (context, index) => _ChildItemWidget(
                child: controller.children[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChildItemWidget extends StatelessWidget {
  const _ChildItemWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Child child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => HomeController.instance.child.value = child,
      child: Scope(
        builder: (_) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInBack,
          color: HomeController.instance.child.value == child
              ? Colors.amber
              : Colors.transparent,
          child: Row(
            children: [
              const SizedBox(width: 8),
              Text(child.name),
              const Spacer(),
              IconButton(
                onPressed: () => SettingsController.instance.delete(child),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ParentsWidget extends StatelessWidget {
  const _ParentsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scope(
      builder: (_) {
        final controller = SettingsController.instance;
        final home = HomeController.instance;
        if (home.child.value == null) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  'Parents',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.addParent,
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Scope(
                builder: (_) => ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: home.child.value!.parents.length,
                  itemBuilder: (context, index) => Text(
                    home.child.value!.parents[index],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChildInfoWidget extends StatelessWidget {
  const _ChildInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scope(builder: (_) {
      final home = HomeController.instance;
      if (home.child.value == null) {
        return const SizedBox.shrink();
      }
      return const _ChildEditInfoWidget();
    });
  }
}

class _ChildEditInfoWidget extends StatefulWidget {
  const _ChildEditInfoWidget({Key? key}) : super(key: key);

  @override
  State<_ChildEditInfoWidget> createState() => _ChildEditInfoWidgetState();
}

class _ChildEditInfoWidgetState extends State<_ChildEditInfoWidget> {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();

  @override
  void initState() {
    HomeController.instance.child.addListener(update);
    update();
    super.initState();
  }

  void update() {
    final con = HomeController.instance;
    nameController.text = con.child.value!.name;
    birthdayController.text =
        con.child.value!.birthday.toString().substring(0, 10);
  }

  @override
  void dispose() {
    HomeController.instance.child.removeListener(update);
    nameController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child:
                Text('Details', style: Theme.of(context).textTheme.titleLarge),
          ),
          TextField(controller: nameController),
          TextField(controller: birthdayController),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Save'),
              )
            ],
          )
        ],
      ),
    );
  }
}
