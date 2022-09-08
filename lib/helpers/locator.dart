import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

/// register the global service to the DI
Future<void> registerInstances() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

/// The base controller definitions
abstract class BaseController {
  /// a method will run after creating the controller
  Future<void> onInit() async {}

  /// a method will run before remove the controller
  Future<void> onExit() async {}
}
