import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/child.dart';
import 'package:dio/dio.dart';

import '../../../helpers/constants.dart';
import '../../../services/auth_service.dart';

class SettingsService extends BaseController {
  final _dio = locator<Dio>();
  final _auth = locator<AuthService>();

  Future<List<Child>?> getChildren() async {
    final result = await _dio.get('/child', options: _auth.auth);

    if (result.statusCode != 200) {
      showError(result.data.toString());
      return null;
    }

    final records = result.data as List;
    if (records.isEmpty) {
      return <Child>[];
    }

    return records.map((e) => Child.fromMap(e)).toList();
  }

  Future<Child?> getChild(int id) async {
    final result = await _dio.get('/child/$id', options: _auth.auth);

    if (result.statusCode != 200) {
      showError(result.data.toString());
      return null;
    }

    return Child.fromMap(result.data);
  }

  Future<bool> delete(int id) async {
    final result = await _dio.delete('/child/$id', options: _auth.auth);

    if (result.statusCode != 204) {
      showError(result.data.toString());
      return false;
    }

    return true;
  }

  Future<Child?> add(String name, DateTime birthday) async {
    final result = await _dio.post('/child', options: _auth.auth, data: {
      'name': name.trim(),
      'birthday': birthday.toUtc().toIso8601String(),
    });

    if (result.statusCode != 200) {
      showError(result.data.toString());
      return null;
    }

    return Child.fromMap(result.data);
  }

  Future<Child?> edit(int id, String name, DateTime birthday) async {
    final result = await _dio.put('/child', options: _auth.auth, data: {
      'id': id,
      'name': name.trim(),
      'birthday': birthday.toUtc().toIso8601String(),
    });

    if (result.statusCode != 200) {
      showError(result.data.toString());
      return null;
    }

    return Child.fromMap(result.data);
  }

  Future<Child?> addParent(int id, String email) async {
    final result = await _dio.post('/child/parent', options: _auth.auth, data: {
      'childId': id,
      'ParentEmail': email.trim(),
    });

    if (result.statusCode != 200) {
      showError(result.data.toString());
      return null;
    }

    return Child.fromMap(result.data);
  }

  Future<Child?> removeParent(int id, String email) async {
    final result =
        await _dio.delete('/child/parent', options: _auth.auth, data: {
      'childId': id,
      'ParentEmail': email.trim(),
    });

    if (result.statusCode != 200) {
      showError(result.data.toString());
      return null;
    }

    return Child.fromMap(result.data);
  }
}
