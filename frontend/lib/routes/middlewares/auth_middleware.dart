import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/services/auth_service.dart';
import 'package:qlevar_router/qlevar_router.dart';

/// this middleware will check if the user is logged in to process to the requested page,
/// otherwise the this middleware will redirect to login page.
class AuthMiddleware extends QMiddleware {
  @override
  Future<String?> redirectGuard(String path) async {
    return locator<AuthService>().isAuth ? null : '/login';
  }
}
