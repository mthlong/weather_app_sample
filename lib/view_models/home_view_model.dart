import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_sample/core/data/models/city_model.dart';
import 'package:weather_app_sample/core/data/remote/entity/hour_weather.dart';
import 'package:weather_app_sample/view_models/base_view_model.dart';

import '../components/network_utility.dart';
import '../core/data/remote/entity/weather_entity.dart';
import '../core/ultis/temperature_convert.dart';
import '../ui/views/add_city_view.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel();

  List<HourWeather> _listWeather = [];

  List<HourWeather> get listWeather => _listWeather;

  static CityModel? _selectedCity;

  static CityModel? get selectedCity => _selectedCity;

  @override
  Future<void> onInitViewModel(BuildContext context) async {
    super.onInitViewModel(context);
    await initData();
  }

  Future<void> initData({double? lat, double? lng, String? name}) async {
    if (lng != null && lng != null) {
      Uri uri = Uri.https("api.openweathermap.org", 'data/2.5/weather', {
        "lat": lat.toString(),
        "lon": lng.toString(),
        "appid": "4ee1a7b249f7b213a2ca788d7f0a02d3",
      });
      Uri uriHourWeather =
          Uri.https("api.openweathermap.org", 'data/2.5/forecast', {
        "lat": lat.toString(),
        "lon": lng.toString(),
        "cnt": "5",
        "appid": "4ee1a7b249f7b213a2ca788d7f0a02d3",
      });
      try {
        final response = await NetworkUtility.fetchUrl(uri);
        final responseList = await NetworkUtility.fetchUrl(uriHourWeather);
        if (response != null && responseList != null) {
          final parsed = json.decode(response).cast<String, dynamic>();
          final parsedList = json.decode(responseList).cast<String, dynamic>();
          CityModel cityModel = CityModel.fromJson(parsed, parsedList);
          cityModel.setLat(lat);
          cityModel.setName(name);
          cityModel.setLng(lng);
          _listWeather = cityModel.getListHourWeather!;
          setSelectedCity(cityModel);
        }
        updateUI();
        updateCurrentUI();
      } catch (e) {
        rethrow;
      }
    }
  }

  void goToAddCityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCity()),
    );
  }

  Future<void> getWeather(double? lat, double? lng, String? name) async {
    await initData(lat: lat, lng: lng, name: name);
  }

  void setSelectedCity(CityModel cityModel) {
    _selectedCity = cityModel;
  }
}
