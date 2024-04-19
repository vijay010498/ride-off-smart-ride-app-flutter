import 'dart:convert';
import 'package:ride_off_smart_ride_app_flutter/services/storage/secureStorageService.dart';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';
import '../main.dart';

class RiderFindRideService {

  Future<bool> findRide(
      {required String startAddress,
      required String destinationAddress,
      required String leaving,
      required int seats,
      int? maxPrice,
      String? rideDescription}) async {
    try {

      final String? accessToken =
      await storageService.read(SecureStorageService.keyAccessToken);
      Map<String, dynamic> payload = {
        'fromPlaceId': startAddress,
        'toPlaceId': destinationAddress,
        'departing': leaving,
        'seats': seats,
      };

      if (maxPrice != null) {
        payload['maxPrice'] = maxPrice;
      }

      if (rideDescription != null) {
        payload['rideDescription'] = rideDescription;
      }

      final String jsonPayload = jsonEncode(payload);
      final response = await HttpClient.sendRequest(HttpMethod.POST, jsonPayload,
          '${ApiConfig.baseUrl}${ApiConfig.passengerFindRideEndPoint}',
          authToken: accessToken);

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('findRde-error---$error',);
      return false;
    }
  }
}
