import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app_sample/components/network_utility.dart';
import 'package:weather_app_sample/core/data/models/city_model.dart';

import '../../core/data/remote/entity/city_entity.dart';
import '../../core/data/response/place_auto_complete_response.dart';
import '../../view_models/home_view_model.dart';
import '../shared/fonts.dart';



class AddCity extends StatefulWidget {
  const AddCity({super.key});

  @override
  State<AddCity> createState() => _AddCityState();
}

TextEditingController _searchController = TextEditingController();

class _AddCityState extends State<AddCity> {

  List<City> cities = [];

  Future<void> _placeAutoComplete(String query) async {
    Uri uri =
        Uri.https("wft-geo-db.p.rapidapi.com", 'v1/geo/cities', {
      "namePrefix": query,
    });

    Map<String, String> headers = {
      'X-RapidAPI-Key': '877bc6ce53mshd56d8729583a30dp132934jsn5f3397aeb43e',
      'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com'
    };

    await NetworkUtility.fetchUrl(uri, headers: headers).then((response) {
      if (response != null) {
        PlaceAutoCompleteResponse result =
            PlaceAutoCompleteResponse.parseAutoCompleteResult(response);
        if (result.cities != null) {
          setState(() {
            cities = result.cities!;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    AppBar appBar = _buildAppBar();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.only(top: appBar.preferredSize.height + 30),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background_image.png'),
                fit: BoxFit.fill)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 90.0, sigmaY: 90.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 60,
                  child: TextField(
                    style: safeGoogleFont(
                      'SF Pro Text',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    onSubmitted: (s) {
                      _placeAutoComplete(s);
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name or zip code...',
                      hintStyle: safeGoogleFont(
                        'SF Pro Text',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () => _searchController.clear(),
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // Perform the search here
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: _buildListCity(height)))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCity(double height) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
      child: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, selectedIndex) {
          return _buildItemCity(cities[selectedIndex], height);
        },
      ),
    );
  }

  Widget _buildItemCity(City item, double height) {
    return GestureDetector(
      onTap: () => _processClickItem(item, context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: height / 15,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                end: Alignment.bottomRight,
                begin: Alignment.topLeft,
                colors: [Color(0xff48319D), Color(0xffDDAEF2)]),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 2, color: Colors.white30)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ),
              Expanded(
                  child: _buildText(
                      text: item.address ?? "",
                      fontSize: 14,
                      fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            _buildText(
                text: "Add city", fontSize: 30, fontWeight: FontWeight.w300),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Future<void> _processClickItem(City item, BuildContext context) async {
      await HomeViewModel().getWeather(item.lat, item.lng, item.name);
      Navigator.of(context).pop();
  }

  Widget _buildText(
      {required String text,
      double? fontSize,
      FontWeight? fontWeight,
      TextAlign? textAlign,
      Color? color}) {
    return Text(text,
        textAlign: textAlign ?? TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: safeGoogleFont(
          'SF Pro Text',
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? Colors.white,
        ));
  }

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }
}
