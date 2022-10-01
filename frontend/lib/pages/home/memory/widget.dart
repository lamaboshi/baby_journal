import 'package:baby_journal/pages/home/controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../models/memory.dart';

class MemoryWidget extends StatelessWidget {
  final Memory memory;
  final double height;
  const MemoryWidget({
    required this.memory,
    this.height = 300,
    Key? key,
  }) : super(key: key);

  static final _formatter = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final child = HomeController.instance.child.value!;
    return InkWell(
      onTap: () {
        QR.to('/home/memories/${memory.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(memory.image),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 5,
              blurRadius: 5,
            )
          ],
        ),
        margin: const EdgeInsets.all(10),
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.white24,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(memory.title!, style: text.titleLarge),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_formatter.format(memory.at)),
                    Text(child.age(today: memory.at)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
