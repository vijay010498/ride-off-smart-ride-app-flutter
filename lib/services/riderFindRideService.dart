import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/secureStorageService.dart';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';

class RiderFindRideService{
    final SecureStorageService secureStorageService = SecureStorageService();
    
    Future<Map<String, dynamic>> findRide(String startAddress, String destinationAddress, String leaving, int seats, int maxPrice, String? rideDescription) async {
      print(startAddress);
      final String? accessToken = await secureStorageService.read(SecureStorageService.keyAccessToken);
      //Logger log = new Logger();
      final payload = jsonEncode({'fromPlaceId': startAddress,'toPlaceId':destinationAddress, 'departing' :leaving, 'seats': seats, 'maxPrice': maxPrice, 'rideDescription': rideDescription});
      final response =  await HttpClient.sendRequest(HttpMethod.POST, payload, '${ApiConfig.baseUrl}${ApiConfig.passengerFindRideEndPoint}',authToken: accessToken);
     Logger log = new Logger();
        log.i('response service2: ${response.statusCode}');
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
    } else {
        return {'error': 'Failed to create ride: ${response.statusCode}'};
    }
  }
}