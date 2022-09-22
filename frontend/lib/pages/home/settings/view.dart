import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/settings/controller.dart';
import 'package:baby_journal/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {
              locator<AuthService>().logout();
              QR.navigator.replaceAll('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _ChildrenWidget(),
              _ChildSectionWidget(),
            ],
          ),
        ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            Scope(
              builder: (_) => ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.children.length,
                itemBuilder: (context, index) => _ChildItemWidget(
                  child: controller.children[index],
                ),
              ),
            ),
          ],
        ),
      ),
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
      onTap: () => SettingsController.instance.setChild(child),
      child: Scope(
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: HomeController.instance.child.value?.id == child.id
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Text(child.name),
              const Spacer(),
              IconButton(
                onPressed: () => SettingsController.instance.delete(child),
                icon: const Icon(Icons.delete),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ChildSectionWidget extends StatelessWidget {
  const _ChildSectionWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            _FamilyWidget(),
            _ChildInfoWidget(),
          ],
        ),
      ),
    );
  }
}

class _FamilyWidget extends StatelessWidget {
  const _FamilyWidget({
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
                Text(
                  'Family',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.addParent,
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            Scope(
              builder: (_) => ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: home.child.value!.family.length,
                itemBuilder: (context, index) => Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(home.child.value!.family[index].name),
                    const Spacer(),
                    IconButton(
                      onPressed: () => SettingsController.instance
                          .removeParent(home.child.value!.family[index]),
                      icon: const Icon(Icons.delete),
                    )
                  ],
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
        con.child.value!.birthday.toLocal().toString().substring(0, 10);
  }

  @override
  void dispose() {
    if (locator.isRegistered<HomeController>()) {
      HomeController.instance.child.removeListener(update);
    }
    nameController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Child info',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        TextField(controller: nameController),
        TextField(controller: birthdayController),
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () => SettingsController.instance
                  .update(nameController.text, birthdayController.text),
              child: const Text('Save'),
            )
          ],
        )
      ],
    );
  }
}
