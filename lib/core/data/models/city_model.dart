import 'package:weather_app_sample/core/data/remote/entity/hour_weather.dart';

import '../../ultis/temperature_convert.dart';

class CityModel {
  String? name;
  double? lat;
  double? lng;
  int? temperature;
  String? weatherStateName;
  int? humidity;
  int? windSpeed;
  int? maxTemp;


  List<HourWeather>? listHourWeather;

  List<HourWeather>? get getListHourWeather => listHourWeather;

  set setListHourWeather(List<HourWeather>? listHourWeather) {
    listHourWeather = listHourWeather;
  }

  String? get getName => name;

  void setName(String? value) {
    name = value;
  }

  double? get getLat => lat;

  void setLat(double? value) {
    lat = value;
  }

  double? get getLng => lng;

  void setLng(double? value) {
    lng = value;
  }

  CityModel(
      {this.name,
      this.lat,
      this.lng,
      this.temperature,
      this.weatherStateName,
      this.humidity,
      this.windSpeed,
      this.maxTemp,
      this.listHourWeather});

  factory CityModel.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> jsonList) {
    return CityModel(
      humidity: json["main"]["humidity"],
      maxTemp: kelvinToCelsius(json["main"]["temp_max"].round()),
      temperature: kelvinToCelsius(json["main"]["temp"].round()),
      weatherStateName: json["weather"][0]["main"],
      windSpeed: json["wind"]["speed"].round(),
      listHourWeather: jsonList["list"]
          ?.map<HourWeather>((json) => HourWeather.fromJson(json))
          .toList(),
    );
  }

  @override
  String toString() =>
      "{lat: $lat, lng: $lng, name: $name, temp: $temperature, weatherState: $weatherStateName, humidity: $humidity, length: ${listHourWeather?.length}";

  void setWeatherStateName(String? value) {
    weatherStateName = value;
  }
}
