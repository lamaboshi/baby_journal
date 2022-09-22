import 'package:baby_journal/helpers/locator.dart';
import 'package:baby_journal/models/memory.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/constants.dart';
import '../../../services/auth_service.dart';

class MemoriesService extends BaseController {
  final _dio = locator<Dio>();
  final _auth = locator<AuthService>();

  Future<void> add(Memory memory) async {
    final s = memory.toJson();
    final result = await _dio.post(
      '/memory',
      options: _auth.auth,
      data: memory.toMap(),
    );

    if (result.statusCode != 204) {
      showError(result.data.toString());
    }
  }

  Future<void> edit(Memory memory) async {
    final result = await _dio.put(
      '/memory/${memory.id}',
      options: _auth.auth,
      data: memory.toMap(),
    );

    if (result.statusCode != 204) {
      showError(result.data.toString());
    }
  }

  Future<void> delete(int id) async {
    final result = await _dio.put(
      '/memory/$id',
      options: _auth.auth,
    );

    if (result.statusCode != 204) {
      showError(result.data.toString());
    }
  }

  Future<Memory> get(int id) async {
    final result = await _dio.get(
      '/memory/$id',
      options: _auth.auth,
    );

    if (result.statusCode != 200) {
      showError(result.data.toString());
    }

    return Memory.fromMap(result.data as Map<String, dynamic>);
  }

  Future<String> addImage(int childId, XFile file) async {
    final fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final response = await _dio.post(
      "/images",
      options: _auth.auth,
      data: formData,
      queryParameters: {'childId': childId},
    );
    return response.data['path'];
  }

  Future<List<Memory>> getRandom(int childId) async {
    final response = await _dio.get(
      "/child/$childId/memory/random",
      options: _auth.auth,
    );
    if (response.statusCode != 200) {
      return [];
    }
    return List<Memory>.from(response.data.map((x) => Memory.fromMap(x)));
  }

  Future<PagedMemories?> getAll(int childId, int offset, int limit) async {
    final response = await _dio.get(
      "/child/$childId/memory",
      options: _auth.auth,
      queryParameters: {'offset': offset, 'limit': limit},
    );
    if (response.statusCode != 200) {
      return null;
    }
    return PagedMemories.fromMap(response.data);
  }
}
