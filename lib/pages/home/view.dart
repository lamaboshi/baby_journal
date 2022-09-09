import 'package:baby_journal/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class HomeView extends StatefulWidget {
  final QRouter router;
  const HomeView(this.router, {super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    widget.router.navigator.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    widget.router.navigator.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widget.router),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(0),
            ),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        //    color: Colors.indigo,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _IconItem(icon: Icons.home, index: 0),
            _IconItem(icon: Icons.timeline, index: 1),
            SizedBox.shrink(),
            _IconItem(icon: Icons.list, index: 2),
            _IconItem(icon: Icons.settings, index: 3),
          ],
        ),
      ),
    );
  }
}

class _IconItem extends StatelessWidget {
  final IconData icon;
  final int index;
  const _IconItem({required this.icon, required this.index});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.orange,
      ),
      onPressed: () => _goTo(index),
    );
  }

  _goTo(int i) {
    QR.toName(AppRoutes.tabs[i]);
  }
}
