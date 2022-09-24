part of 'view.dart';

class _ImageSection extends StatelessWidget {
  const _ImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = MemoryDetailsController.instance;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: controller.networkImage != null
          ? CachedNetworkImage(
              imageUrl: controller.networkImage!,
            )
          : Scope(
              builder: (_) => controller.image.value == null
                  ? const _PickImage()
                  : Image.file(File(controller.image.value!.path)),
            ),
    );
  }
}

class _PickImage extends StatelessWidget {
  const _PickImage();

  @override
  Widget build(BuildContext context) {
    final controller = MemoryDetailsController.instance;
    return Column(
      children: [
        Text('Pick image', style: Theme.of(context).textTheme.titleLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => controller.pickImage(ImageSource.camera),
              icon: const Icon(
                Icons.camera,
                size: 50,
              ),
            ),
            IconButton(
              onPressed: () => controller.pickImage(ImageSource.gallery),
              icon: const Icon(
                Icons.image,
                size: 50,
              ),
            )
          ],
        ),
      ],
    );
  }
}
