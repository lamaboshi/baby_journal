import 'package:dio/dio.dart';

import '../helpers/locator.dart';
import '../models/user.dart';
import 'storage_service.dart';

/// The authentication service to see if there is a logged in user or not
/// and it has the login/logout methods.
class AuthService {
  User? user;

  bool get isAuth => user != null;

  Options get auth => Options(
        headers: {'Authorization': 'Bearer ${user!.token}'},
      );

  Future<void> init() async {
    final data = locator<StorageService>().getString(StorageKeys.userData);
    if (data == null || data.isEmpty) {
      return;
    }
    await login(User.fromJson(data));
  }

  /// Send the login request and save the data in the local storage and
  /// set the user as logged in and return null when the request success,
  /// otherwise return the error message.
  Future<String?> login(User user) async {
    final dio = locator<Dio>();
    try {
      final result = await dio.post('/auth/log-in', data: user.toMap());

      if (result.statusCode != 200) {
        return result.data.toString();
      }
      this.user = User.fromMap(result.data as Map<String, dynamic>);

      locator<StorageService>().setString(StorageKeys.userData,
          this.user!.copyWith(password: user.password).toJson());
    } on DioError catch (e) {
      return e.response?.data != null ? e.response!.data : e.error.toString();
    } catch (e) {
      return e.toString();
    }

    return null;
  }

  Future<String?> signUp(User user) async {
    final dio = locator<Dio>();
    try {
      final result = await dio.post(
        'auth/sign-up',
        data: user.toMap(),
      );

      if (result.statusCode != 200) {
        return result.data.toString();
      }

      this.user = User.fromMap(result.data as Map<String, dynamic>);

      locator<StorageService>().setString(
        StorageKeys.userData,
        this.user!.copyWith(password: user.password).toJson(),
      );
    } on DioError catch (e) {
      return e.response?.data != null ? e.response!.data : e.error.toString();
    } catch (e) {
      return e.toString();
    }

    return null;
  }

  /// remove the login data from the local storage the set the user as logged out.
  void logout() {
    locator<StorageService>().remove(StorageKeys.userData);
    user = null;
  }
}
