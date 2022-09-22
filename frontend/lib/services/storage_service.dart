import 'package:shared_preferences/shared_preferences.dart';

/// The storage service of the app.
class StorageService {
  SharedPreferences? _instance;

  /// prepare the local storage for later using
  Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  // set a value to the local storage
  void setString(StorageKeys key, String value) =>
      _instance!.setString(key.name, value);
  void setInt(StorageKeys key, int value) => _instance!.setInt(key.name, value);

  // get a value from the local storage
  String? getString(StorageKeys key) => _instance!.getString(key.name);
  int? getInt(StorageKeys key) => _instance!.getInt(key.name);

  // remove value from the local storage
  void remove(StorageKeys key) => _instance!.remove(key.name);
}

/// The keys to use with the local storage
enum StorageKeys {
  selectedChild,
  userData,
}
