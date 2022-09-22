import 'dart:io';

import 'package:baby_journal/services/auth_service.dart';
import 'package:baby_journal/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final locator = GetIt.instance;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/// register the global service to the DI
Future<void> registerInstances() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  final storage = StorageService();
  await storage.init();
  locator.registerSingleton(storage);
  final dio = Dio(BaseOptions(
    //  baseUrl: 'https://127.0.0.1:7034/api/',
    baseUrl: 'https://10.0.2.2:7034/api/',
    validateStatus: (s) => true,
  ));
  dio.interceptors.add(PrettyDioLogger());
  locator.registerSingleton(dio);
  final auth = AuthService();
  await auth.init();
  locator.registerSingleton(auth);
}

/// The base controller definitions
abstract class BaseController {
  /// a method will run after creating the controller
  Future<void> onInit() async {}

  /// a method will run before remove the controller
  Future<void> onExit() async {}
}
