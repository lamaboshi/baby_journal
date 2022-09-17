import 'package:baby_journal/services/auth_service.dart';
import 'package:baby_journal/services/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

/// register the global service to the DI
Future<void> registerInstances() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  locator.registerSingleton(storage);
  locator.registerSingleton(AuthService());
  locator.registerSingleton(Dio(BaseOptions(
    baseUrl: 'https://localhost:7034/api/',
  )));
}

/// The base controller definitions
abstract class BaseController {
  /// a method will run after creating the controller
  Future<void> onInit() async {}

  /// a method will run before remove the controller
  Future<void> onExit() async {}
}
