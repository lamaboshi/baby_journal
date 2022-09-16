import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

class InputsPanel extends StatelessWidget {
  final void Function(String) param1;
  final void Function(String)? param2;
  final String label1;
  final String? label2;
  const InputsPanel({
    Key? key,
    required this.param1,
    required this.label1,
    this.param2,
    this.label2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onChanged: param1,
            decoration: InputDecoration(
              label: Text(label1),
            ),
          ),
          if (param2 != null)
            TextFormField(
              onChanged: param2,
              decoration: InputDecoration(
                label: Text(label2!),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  param1('');
                  if (param2 != null) {
                    param2!('');
                  }
                  Overlayment.dismissLast();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: Overlayment.dismissLast,
                child: const Text('Add'),
              )
            ],
          )
        ],
      ),
    );
  }
}
