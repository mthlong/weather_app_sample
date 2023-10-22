import 'dart:convert';

import '../remote/entity/auto_complete_prediction_entity.dart';
import '../remote/entity/city_entity.dart';

class PlaceAutoCompleteResponse {
  final List<City>? cities;

  PlaceAutoCompleteResponse({this.cities});

  factory PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutoCompleteResponse(
      cities: json["data"]
          ?.map<City>(
              (json) => City.fromJson(json))
          .toList(),
    );
  }

  static PlaceAutoCompleteResponse parseAutoCompleteResult(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutoCompleteResponse.fromJson(parsed);
  }
}
