import 'package:universal_html/html.dart' as html;
import 'package:encrypt/encrypt.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/storage_service.dart';

class WebStorageService implements StorageService {
  late final Key key;
  late final IV iv;
  late final Encrypter encrypter;

  WebStorageService() {
    key = Key.fromLength(32);
    iv = IV.fromLength(8);

    encrypter = Encrypter(Salsa20(key));
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      final encrypted = encrypter.encrypt(value, iv: iv);
      html.window.localStorage[key] = encrypted.base64;
    } catch (e) {
      print("Error encrypting data: $e");
    }
  }

  @override
  Future<String?> read(String key) async {
    try {
      final String? encryptedValue = html.window.localStorage[key];
      if (encryptedValue != null) {
        return encrypter.decrypt(Encrypted.fromBase64(encryptedValue), iv: iv);
      }
    } catch (e) {
      print("Error decrypting data: $e");
    }
    return null;
  }

  @override
  Future<void> delete(String key) async {
    html.window.localStorage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    html.window.localStorage.clear();
  }
}
