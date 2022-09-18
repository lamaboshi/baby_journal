import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MemorySavedWidget extends StatelessWidget {
  const MemorySavedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Memory Saved',
            style: Theme.of(context).textTheme.headline3,
          ),
          LottieBuilder.asset('assets/data-saved.json')
        ],
      ),
    );
  }
}
