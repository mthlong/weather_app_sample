import 'package:weather_app_sample/core/ultis/temperature_convert.dart';

import '../../../ultis/date_time_utils.dart';

class HourWeather {
  final int? temp;
  final String? status;
  final String? hour;

  HourWeather({required this.temp, required this.status, required this.hour});

  factory HourWeather.fromJson(Map<String, dynamic> json) {
    return HourWeather(
        temp: kelvinToCelsius(json["main"]["temp"].round()),
        status: json["weather"][0]["main"] as String?,
        hour: convertHour(json["dt_txt"]));
  }
}
