import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/storage_service.dart';

class MobileStorageService implements StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }

}