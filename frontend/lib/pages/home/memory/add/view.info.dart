part of 'view.dart';

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _AgeSection(),
        Divider(),
        _TextSection(),
        _BodySection(),
      ],
    );
  }
}

class _AgeSection extends StatelessWidget {
  const _AgeSection();

  @override
  Widget build(BuildContext context) {
    final controller = MemoryDetailsController.instance;
    final formatter = DateFormat.yMMMd();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: controller.changeDate,
        child: Scope(
          builder: (_) => Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 8),
              Text(
                formatter.format(controller.date.value),
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(width: 8),
              Text(controller.child.age(today: controller.date.value)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodySection extends StatelessWidget {
  const _BodySection();

  @override
  Widget build(BuildContext context) {
    final controller = MemoryDetailsController.instance;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: controller.weight.toString(),
              decoration: const InputDecoration(
                label: Text('Wight'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.weight.value = double.parse(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: controller.length.toString(),
              decoration: const InputDecoration(
                label: Text('Length'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.length.value = double.parse(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection();

  @override
  Widget build(BuildContext context) {
    final controller = MemoryDetailsController.instance;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: controller.title.value,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              label: const Text('Title'),
              border: const OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.headline4,
            ),
            onChanged: (value) {
              controller.title.value = value;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: controller.text.value,
            minLines: 2,
            maxLines: 10,
            decoration: const InputDecoration(
              label: Text('Text'),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              controller.text.value = value;
            },
          ),
        ],
      ),
    );
  }
}
