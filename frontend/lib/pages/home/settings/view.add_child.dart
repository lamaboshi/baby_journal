import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlayment/overlayment.dart';
import 'package:reactable/reactable.dart';

import 'controller.dart';

class AddChildInfo extends StatelessWidget {
  const AddChildInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var name = '';
    var birthday = DateTime.now().asReactable;
    final controller = SettingsController.instance;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 8,
        left: 8,
        right: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            onChanged: (v) => name = v,
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
          ),
          const SizedBox(height: 8),
          Scope(
            builder: (_) => InkWell(
              onTap: () {
                showDatePicker(
                  context: Overlayment.navigationKey!.currentContext!,
                  initialDate: birthday.value,
                  firstDate: DateTime(1980),
                  lastDate: DateTime.now(),
                ).then((value) {
                  if (value == null) {
                    return;
                  }
                  birthday(value);
                });
              },
              child: _AgeSection(birthday.value),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  controller.addingChild.value = !controller.addingChild.value;
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (name.isEmpty) return;
                  controller.addChild(name, birthday.value);
                },
                child: const Text('Add'),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _AgeSection extends StatelessWidget {
  final DateTime date;
  const _AgeSection(this.date);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 8),
        Text(formatter.format(date)),
        const SizedBox(width: 8),
        Text(age),
      ],
    );
  }

  String get age {
    final value = AgeCalculator.age(date);
    return '${value.years}Y ${value.months}M ${value.days}D';
  }
}
