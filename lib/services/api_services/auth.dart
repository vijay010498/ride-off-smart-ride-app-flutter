import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';
import 'package:ride_off_smart_ride_app_flutter/config/apiconfig.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/httpclient.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../storage/secureStorageService.dart';

class AuthService {
  final SecureStorageService secureStorageService = SecureStorageService();

  // Keys for secure storage
  static const String _keyAccessToken = SecureStorageService.keyAccessToken;
  static const String _keyRefreshToken = SecureStorageService.keyRefreshToken;

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) return {};

      final response = await HttpClient.sendRequest(
        HttpMethod.GET,
        null, // No payload for GET request
        '${ApiConfig.baseUrl}${ApiConfig.currentUserEndpoint}',
        authToken: accessToken,
      );

      if (response.statusCode == 403) {
        // user is blocked
        return {'isBlocked': true};
      }

      if (response.statusCode != 200) {
        await _handleTokenRefresh();
        final newAccessToken = await _getAccessToken();
        if (newAccessToken == null) return {};
        final newCurrentUserResponse = await HttpClient.sendRequest(
          HttpMethod.GET,
          null, // No payload for GET request
          '${ApiConfig.baseUrl}${ApiConfig.currentUserEndpoint}',
          authToken: newAccessToken,
        );
        return jsonDecode(newCurrentUserResponse.body);
      }

      return jsonDecode(response.body);
    } catch (error) {
      print("getCurrentUser-error----$error");
      rethrow;
    }
  }

  Future<String?> _getAccessToken() async {
    return secureStorageService.read(_keyAccessToken);
  }

  Future<void> _handleTokenRefresh() async {
    final refreshToken = await secureStorageService.read(_keyRefreshToken);
    if (refreshToken == null) return;
    final response = await HttpClient.sendRequest(
      HttpMethod.GET,
      null, // No payload for GET request
      '${ApiConfig.baseUrl}${ApiConfig.refreshTokenEndpoint}',
      authToken: refreshToken,
    );

    if (response.statusCode != 200) {
      // refresh token failed - delete both access and refresh token
      await secureStorageService.delete(_keyRefreshToken);
      await secureStorageService.delete(_keyAccessToken);
      return;
    }

    final responseBody = jsonDecode(response.body);
    final newAccessToken = responseBody['accessToken'];
    final newRefreshToken = responseBody['refreshToken'];

    await secureStorageService.write(_keyAccessToken, newAccessToken);
    await secureStorageService.write(_keyRefreshToken, newRefreshToken);
  }

  Future updateUserLocation(double longitude, double latitude) async {
    try {
      // Compare last location to check should we make the API call
      var lastLongitude =
      await secureStorageService.read(SecureStorageService.KeyLongitude);
      var lastLatitude =
      await secureStorageService.read(SecureStorageService.KeyLatitude);

      if (lastLongitude != null && lastLatitude != null) {
        if (double.parse(lastLongitude) == longitude &&
            double.parse(lastLatitude) == latitude) {
          return;
        }
      }
      final payload =
      jsonEncode({'longitude': longitude, 'latitude': latitude});
      final authToken = await _getAccessToken();
      final response = await HttpClient.sendRequest(HttpMethod.PATCH, payload,
          '${ApiConfig.baseUrl}${ApiConfig.updateUserLocation}',
          authToken: authToken);

      if (response.statusCode == 204) {
        // Sore the location into storage
        await secureStorageService.write(
            SecureStorageService.KeyLongitude, longitude.toString());
        await secureStorageService.write(
            SecureStorageService.KeyLatitude, latitude.toString());
      }
      if (kDebugMode) {
        print('User-Location-Update:${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      if (kDebugMode) {
        print("updateUserLocation-error----$error");
      }
    }
  }

  Future<bool> logoutUser() async {
    try {
      final authToken = await _getAccessToken();
      await HttpClient.sendRequest(
          HttpMethod.GET, null, '${ApiConfig.baseUrl}${ApiConfig.logoutUser}',
          authToken: authToken);

      // Clear Up all tokens and Locations
      await secureStorageService.deleteAll();

      return true;
    } catch (error) {
      if (kDebugMode) {
        print("logoutUser-error----$error");
      }
      return false;
    }
  }

  Future<List<String>> getVehicleTypes() async {
    try {
      final accessToken = await _getAccessToken();
      final apiResponse = await HttpClient.sendRequest(HttpMethod.GET, null,
          '${ApiConfig.baseUrl}${ApiConfig.getVehicleTypes}',
          authToken: accessToken);

      if (apiResponse.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(apiResponse.body);
        return responseBody.cast<String>();
      } else {
        if (kDebugMode) {
          print(
              "Failed to fetch vehicle types, status code: ${apiResponse
                  .statusCode}");
        }
        return [];
      }
    } catch (error) {
      if (kDebugMode) {
        print("getVehicleTypes-error----$error");
      }
      return [];
    }
  }

  Future<bool> createNewVehicle(List<File> vehicleImages,
      String model,
      String type,
      String color,
      String year,
      String licensePlate,
      String averageKmPerLitre,) async {
    try {
      final accessToken = await _getAccessToken();

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createNewVehicle}')
      );

      for (var imageFile in vehicleImages) {
        request.files.add(
            await http.MultipartFile.fromPath(
              'vehicleImages',
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            )
        );
      }

      request.fields['model'] = model;
      request.fields['type'] = type;
      request.fields['color'] = color;
      request.fields['year'] = year;
      request.fields['licensePlate'] = licensePlate;
      request.fields['averageKmPerLitre'] = averageKmPerLitre;

      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (error) {
      if (kDebugMode) {
        print('createNewVehicle-error----$error');
      }
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getUserVehicles() async {
    try {
      final accessToken = await _getAccessToken();

      final userVehiclesResponse = await HttpClient.sendRequest(
        HttpMethod.GET,
        null,
        '${ApiConfig.baseUrl}${ApiConfig.getUserVehicles}',
        authToken: accessToken,
      );

      if (userVehiclesResponse.statusCode == 200) {
        List<dynamic> jsonList = json.decode(userVehiclesResponse.body);
        List<Map<String, dynamic>> vehicles = jsonList.map((e) => e as Map<String, dynamic>).toList();
        return vehicles;
      } else {
        throw Exception('Failed to fetch user vehicles');
      }
    } catch (error) {
      if (kDebugMode) {
        print("getUserVehicles-error----$error");
      }
      rethrow;
    }
  }

  Future updateUserStatus() async {
    try {
      final accessToken = await _getAccessToken();
      final updateUserStatusResponse = await Htt
    } catch(error) {
      if (kDebugMode) {
        print("getUserVehicles-error----$error");
      }
      rethrow;
    }
  }

}
