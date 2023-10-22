import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_sample/core/data/models/city_model.dart';
import 'package:weather_app_sample/core/data/remote/entity/hour_weather.dart';
import 'package:weather_app_sample/ui/views/add_city_view.dart';
import 'package:weather_app_sample/ui/views/base_view.dart';

import '../../core/data/remote/entity/weather_entity.dart';
import '../../view_models/home_view_model.dart';
import '../shared/colors.dart';
import '../shared/dimens/dimens_manager.dart';
import '../shared/dimens/home_view_dimen.dart';
import '../shared/fonts.dart';
import 'list_city_view.dart';

class HomeView extends BaseView {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState
    extends BaseViewState<HomeView, HomeViewModel, DimenHomeView> {
  String _imageUrl = '';

  final List<BoxShadow> _boxShadowAddIcon = [
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: 3,
      blurRadius: 50,
      offset: const Offset(0, 0),
    ),
  ];

  final List<BoxShadow> _boxShadowIcon = [
    BoxShadow(
      color: const Color(0xff7582F4).withOpacity(0.5),
      spreadRadius: 3,
      blurRadius: 30,
      offset: const Offset(0, 0),
    ),
  ];

  @override
  void createDimens() {
    super.createDimens();
    viewSize = DimensManager().homeViewSize;
  }

  @override
  void calculatorSizeForOtherWidget() {
    DimensManager().calculatorRatio<HomeView>(context);
  }

  @override
  void createViewModel() {
    super.createViewModel();
    viewModel = HomeViewModel()..onInitViewModel(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background_image.png'),
                fit: BoxFit.fill)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Image.asset(
                'assets/images/house.png',
              ),
            ),
            Selector<HomeViewModel, CityModel?>(
                builder: (_, selectedCity, __) {
                  if (selectedCity == null) {
                    return Column(
                      children: [
                        SizedBox(
                          height: height / 3,
                          child: Center(
                            child: _buildText(
                              fontSize: 35,
                              text: "Add a city",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildMainContent(width, height,
                            selectedCity: selectedCity)
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _heightSpace(40),
                      _buildText(
                        text: selectedCity?.name ?? "N/A",
                        fontSize: 45,
                        fontWeight: FontWeight.w600,
                      ),
                      _buildText(
                        text: "${selectedCity?.temperature.toString()}°",
                        fontSize: 92,
                        fontWeight: FontWeight.w200,
                      ),
                      _buildText(
                        text: selectedCity?.weatherStateName ?? "N/A",
                        fontWeight: FontWeight.w500,
                      ),
                      _heightSpace(40),
                      _buildMainContent(width, height,
                          selectedCity: selectedCity)
                    ],
                  );
                },
                selector: (_, viewModel) => HomeViewModel.selectedCity)
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(double width, double height,
      {CityModel? selectedCity}) {
    return Expanded(
        child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 4),
        child: Stack(
          children: [
            _buildBackgroundPanel(width),
            _buildMainPanel(width, height, cityModel: selectedCity),
            _buildBottomButton(width),
          ],
        ),
      ),
    ));
  }

  Positioned _buildBottomButton(double width) {
    return Positioned(
        bottom: 0,
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/bottom_background.png',
                width: width / 1.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(boxShadow: _boxShadowIcon),
                    child: const Icon(
                      Icons.share_location_sharp,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: _boxShadowAddIcon,
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xffDDAEF2), width: 3)),
                      child: GestureDetector(
                        onTap: () => viewModel.goToAddCityScreen(),
                        child: const Icon(
                          Icons.add,
                          size: 40,
                          color: Color(0xffDDAEF2),
                        ),
                      )),
                  Container(
                      decoration: BoxDecoration(boxShadow: _boxShadowIcon),
                      child: GestureDetector(
                        onTap: () => _goToListCityScreen(),
                        child: const Icon(
                          Icons.checklist_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ));
  }

  IntrinsicHeight _buildMainPanel(double width, double height,
      {required CityModel? cityModel}) {
    return IntrinsicHeight(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWidgetContent(width, height, cityModel: cityModel),
              _heightSpace(20),
              _buildLine(),
              _heightSpace(10),
              cityModel != null
                  ? _buildText(
                      text: 'Hour Forecast',
                      fontSize: 24,
                      fontWeight: FontWeight.w500)
                  : const SizedBox(),
              cityModel != null
                  ? _buildWeeklyForecast(height, cityModel: cityModel!)
                  : const SizedBox(),
            ],
          )),
    );
  }

  Container _buildBackgroundPanel(double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Colors.white24, Color(0xffDDAEF2)]),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          border: Border.all(width: 2, color: Colors.white30)),
    );
  }

  void _goToListCityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListCity()),
    );
  }

  Container _buildWeeklyForecast(double height,
      {required CityModel cityModel}) {
    return Container(
      height: height / 5,
      margin: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cityModel.listHourWeather!.length,
        itemBuilder: (context, selectedIndex) {
          final item = cityModel.listHourWeather![selectedIndex];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildItemWeatherList(item),
          );
        },
      ),
    );
  }

  Row _buildWidgetContent(double width, double height,
      {required CityModel? cityModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildWindSpeedWidget(width, height, windSpeed: cityModel?.windSpeed),
        _buildMaxTempWidget(width, height, maxTemp: cityModel?.maxTemp),
      ],
    );
  }

  Container _buildLine() {
    return Container(
        height: 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xffC0C0C0).withOpacity(0.4)));
  }

  Column _buildMaxTempWidget(double width, double height,
      {required int? maxTemp}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _buildText(text: "Max Temperature"),
        ),
        Container(
          width: width / 2.8,
          height: height / 6,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [Color(0xff48319D), Color(0xffDDAEF2)]),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: Colors.white30)),
          child: Row(
            children: [
              Image.asset(
                "assets/images/high_temperature_icon.png",
                width: 60,
                color: Colors.white,
              ),
              _buildText(
                text: maxTemp == null ? "--" : "$maxTemp°",
                fontSize: 39,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
        ),
      ],
    );
  }

  Column _buildWindSpeedWidget(double width, double height,
      {required int? windSpeed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _buildText(text: "Wind speed"),
        ),
        Container(
          width: width / 2.8,
          height: height / 6,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [Color(0xff48319D), Color(0xffDDAEF2)]),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: Colors.white30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      "assets/images/wind_icon.png",
                      width: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    _buildText(text: "WIND")
                  ],
                ),
              ),
              _buildText(text: windSpeed == null ? "--" : "$windSpeed"),
              _buildText(
                  text: "km/h", fontSize: 20, fontWeight: FontWeight.w600),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildText(
      {required String text,
      double? fontSize,
      FontWeight? fontWeight,
      TextAlign? textAlign}) {
    return Text(text,
        textAlign: textAlign ?? TextAlign.start,
        style: safeGoogleFont('SF Pro Text',
            fontSize: fontSize ?? 18,
            fontWeight: fontWeight ?? FontWeight.w400,
            color: HexColors.whiteColor));
  }

  Widget _buildItemWeatherList(HourWeather item) {
    _imageUrl = item.status!.replaceAll(' ', '').toLowerCase();
    return Container(
      width: 50,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              end: Alignment.topLeft,
              begin: Alignment.bottomCenter,
              colors: [Colors.white24, Color(0xffDDAEF2)]),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(width: 2, color: Colors.white30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            item.hour ?? "--",
            textAlign: TextAlign.center,
            style: safeGoogleFont(
              'SF Pro Text',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          ),
          _imageUrl != null
              ? Image.asset(
                  'assets/images/$_imageUrl.png',
                  width: 30,
                )
              : Container(),
          Text(
            item.temp == null ? "--" : "${item.temp}°",
            textAlign: TextAlign.center,
            style: safeGoogleFont(
              'SF Pro Text',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xffffffff),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heightSpace(double height) {
    return SizedBox(height: height);
  }

  Widget _widthSpace(double width) {
    return SizedBox(width: width);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
