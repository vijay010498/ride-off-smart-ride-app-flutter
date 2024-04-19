import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/components/autocomplete_prediction.dart';
import 'dart:convert';

class PlaceAutoCompleteResponse {
  final String? status;
  final List<AutoCompletePrediction>? predictions;

  PlaceAutoCompleteResponse({this.status, this.predictions});

  factory PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json){
    return PlaceAutoCompleteResponse(
      status: json['status' as String?],
      predictions: json['predictions']?.map<AutoCompletePrediction>(
              (json) => AutoCompletePrediction.fromJson(json))
            .toList(),
    );

  }

  static PlaceAutoCompleteResponse parseAutoCompleteResult(String responseBody)
{
  try {
    Logger log = Logger();
    log.i("responseBody: $responseBody");
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutoCompleteResponse.fromJson(parsed);
  } catch(err) {
    print("err: $err");
    throw Exception("Error parsing autocomplete result");
  }
}

}