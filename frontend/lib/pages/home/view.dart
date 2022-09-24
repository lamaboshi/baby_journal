import 'dart:math';

import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/memory/widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:reactable/reactable.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.fill,
          opacity: 0.2,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Scope(
            builder: (_) => controller.child.value == null
                ? const Text('Select a child')
                : Row(
                    children: [
                      Text(
                        controller.child.value!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      Text(
                        controller.child.value!.age(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
          ),
          actions: [
            IconButton(
              onPressed: () => QR.to('/home/settings'),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Scope(
            builder: (_) => controller.child.value == null
                ? const SizedBox.shrink()
                : const _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    final random = Random();
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        children: [
          Lottie.asset('assets/baby-loading.json', height: 250),
          ElevatedButton(
            onPressed: () {
              if (controller.child.value == null) return;
              QR.to('/home/memories/0');
            },
            child: const Text('Add new memory'),
          ),
          ElevatedButton(
            onPressed: () => QR.to('/home/memories'),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Show all memories'),
            ),
          ),
          const SizedBox(height: 32),
          Text('New', style: Theme.of(context).textTheme.titleLarge),
          FutureBuilder(
            future: controller.getLast(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.requireData.isEmpty) {
                return const Text('No memories yet');
              }
              return CarouselSlider.builder(
                itemCount: snapshot.requireData.length - 1,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayAnimationDuration:
                      Duration(seconds: random.nextInt(5) + 1),
                ),
                itemBuilder: (c, i, p) => MemoryWidget(
                  memory: snapshot.requireData[i],
                ),
              );
            },
          ),
          Text('Random', style: Theme.of(context).textTheme.titleLarge),
          FutureBuilder(
            future: controller.getRandom(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.requireData.isEmpty) {
                return const Text('No memories yet');
              }
              return CarouselSlider.builder(
                itemCount: snapshot.requireData.length - 1,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayAnimationDuration:
                      Duration(seconds: random.nextInt(5) + 1),
                ),
                itemBuilder: (c, i, p) => MemoryWidget(
                  memory: snapshot.requireData[i],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
