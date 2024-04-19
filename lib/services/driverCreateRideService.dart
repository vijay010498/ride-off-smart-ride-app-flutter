import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/secureStorageService.dart';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';
import '../main.dart';

class DriverCreateRideService{
    
    Future<Map<String, dynamic>> createRide(String startAddress, String destinationAddress, List<String> stops, String leaving, String vehicleId, String luggage, int emptySeats, String? tripDescription) async {
      final String? accessToken = await storageService.read(SecureStorageService.keyAccessToken);
      //Logger log = new Logger();
      final payload = jsonEncode({'originPlaceId': startAddress,'destinationPlaceId':destinationAddress, 'stops':stops, 'leaving' :leaving, 'vehicleId': vehicleId, 'luggage': luggage, 'emptySeats': emptySeats, 'tripDescription': tripDescription});
      final response =  await HttpClient.sendRequest(HttpMethod.POST, payload, '${ApiConfig.baseUrl}${ApiConfig.driverCreateRideEndPoint}',authToken: accessToken);
     Logger log = Logger();
        log.i('response service1: ${response.statusCode}');
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
    } else {
        return {'error': 'Failed to create ride: ${response.statusCode}'};
    }
  }
}