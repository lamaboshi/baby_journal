import 'package:baby_journal/pages/home/settings/controller.dart';
import 'package:baby_journal/pages/home/settings/view.dart';
import 'package:baby_journal/pages/home/timeline/view.dart';
import 'package:baby_journal/pages/home/view.dart';
import 'package:baby_journal/pages/login/view.dart';
import 'package:baby_journal/routes/middlewares/auth_middleware.dart';
import 'package:baby_journal/routes/middlewares/controller_middleware.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppRoutes {
  static String home = 'home';
  static String login = 'login';
  static List<String> tabs = [
    "Memories Page",
    "timeline Page",
    "to-do Page",
    "Settings Page",
  ];

  // The routes of this app
  final routes = <QRoute>[
    QRoute(
      path: '/login',
      name: login,
      builder: () => const LoginView(),
    ),
    QRoute.withChild(
      path: '/home',
      name: home,
      middleware: [
        AuthMiddleware(),
        //ControllerMid(() => HomeController()),
      ],
      builderChild: (r) => HomeView(r),
      initRoute: '/memories',
      children: [
        QRoute(
          path: '/memories',
          name: tabs[0],
          builder: () => const Text('Memories'),
        ),
        QRoute(
          path: '/timeline',
          name: tabs[1],
          builder: () => const TimelineView(),
        ),
        QRoute(
          path: '/to-do',
          name: tabs[2],
          builder: () => const Text('to-do'),
        ),
        QRoute(
          path: '/settings',
          name: tabs[3],
          middleware: [
            ControllerMid(() => SettingsController()),
          ],
          builder: () => const SettingsView(),
        ),
      ],
    ),
  ];
}
