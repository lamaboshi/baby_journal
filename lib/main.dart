import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers/locator.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerInstances();
  runApp(const TimeTrackingApp());
}

class TimeTrackingApp extends StatelessWidget {
  const TimeTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = QRouterDelegate(AppRoutes().routes, initPath: '/home');
    Overlayment.navigationKey = router.key;
    return MaterialApp.router(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: router,
    );
  }
}
