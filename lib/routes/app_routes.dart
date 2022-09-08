import 'package:baby_journal/pages/home/view.dart';
import 'package:baby_journal/pages/login/view.dart';
import 'package:baby_journal/routes/middlewares/auth_middleware.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppRoutes {
  static String home = 'home';
  static String login = 'login';

  // The routes of this app
  final routes = <QRoute>[
    QRoute(
      path: '/',
      name: home,
      middleware: [
        AuthMiddleware(),
      ],
      builder: () => const HomeView(),
    ),
    QRoute(
      path: '/login',
      name: login,
      builder: () => const LoginView(),
    ),
  ];
}
