import 'package:baby_journal/pages/home/controller.dart';
import 'package:baby_journal/pages/home/memory/controller.dart';
import 'package:baby_journal/pages/home/memory/service.dart';
import 'package:baby_journal/pages/home/memory/view.dart';
import 'package:baby_journal/pages/home/settings/controller.dart';
import 'package:baby_journal/pages/home/settings/service.dart';
import 'package:baby_journal/pages/home/settings/view.dart';
import 'package:baby_journal/pages/home/view.dart';
import 'package:baby_journal/pages/login/controller.dart';
import 'package:baby_journal/pages/login/view.dart';
import 'package:baby_journal/routes/middlewares/auth_middleware.dart';
import 'package:baby_journal/routes/middlewares/controller_middleware.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../pages/home/memory/details/controller.dart';
import '../pages/home/memory/details/view.dart';

class AppRoutes {
  static String home = 'home';
  static String login = 'login';

  // The routes of this app
  final routes = <QRoute>[
    QRoute(
      path: '/login',
      name: login,
      middleware: [
        ControllerMid(
          () => LoginController(),
        )
      ],
      builder: () => const LoginView(),
    ),
    QRoute(
      path: '/home',
      name: home,
      middleware: [
        AuthMiddleware(),
        ControllerMid(() => MemoriesService()),
        ControllerMid(() => HomeController()),
      ],
      builder: () => const HomeView(),
      children: [
        QRoute(
          path: '/memories',
          builder: () => const MemoriesView(),
          middleware: [
            ControllerMid(() => MemoriesController()),
          ],
          children: [
            QRoute(
              path: '/:id',
              middleware: [
                ControllerMid(() => MemoryDetailsController()),
              ],
              builder: () => const MemoryDetailsView(),
            )
          ],
        ),
        QRoute(
          path: '/settings',
          middleware: [
            ControllerMid(() => SettingsService()),
            ControllerMid(() => SettingsController()),
          ],
          builder: () => const SettingsView(),
        ),
      ],
    ),
  ];
}
