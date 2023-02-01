import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/settings/controller.dart';
import 'package:baby_journal/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

import 'view.add_child.dart';

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
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _SelectChildWidget(),
              _AddingNewChildWidget(),
              _ChildSectionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddingNewChildWidget extends StatelessWidget {
  const _AddingNewChildWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Scope(
        builder: (context) {
          if (!SettingsController.instance.addingChild.value) {
            return const SizedBox.shrink();
          }
          return const AddChildInfo();
        },
      ),
    );
  }
}

class _SelectChildWidget extends StatelessWidget {
  const _SelectChildWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Text(
            'Selected Child',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Scope(
              builder: (_) => DropdownButton<Child>(
                value: HomeController.instance.child.value,
                items: controller.children
                    .map(
                      (child) => DropdownMenuItem<Child>(
                        value: child,
                        child: Row(
                          children: [
                            Text(child.name),
                            const Spacer(),
                            IconButton(
                              onPressed: () => controller.delete(child),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                isExpanded: true,
                selectedItemBuilder: (_) => controller.children
                    .map(
                      (child) => Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(child.name),
                      ),
                    )
                    .toList(),
                onChanged: (child) => controller.setChild(child!),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () =>
                controller.addingChild(!controller.addingChild.value),
            icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class _ChildSectionWidget extends ScopedView {
  const _ChildSectionWidget();

  @override
  Widget builder(BuildContext context) {
    final home = HomeController.instance;
    if (home.child.value == null) {
      return const SizedBox.shrink();
    }
    return const ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 8),
      title: Text('Child Info'),
      children: [
        _ChildEditInfoWidget(),
        _FamilyWidget(),
      ],
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.addParent,
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            Scope(
              builder: (_) {
                final currentUser = locator<AuthService>().user!.name;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: home.child.value!.family.length,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: home.child.value!.family[index].name == currentUser
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
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
                );
              },
            ),
          ],
        );
      },
    );
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
