import 'package:flutter/cupertino.dart';
import 'package:weather_app_sample/ui/shared/dimens/home_view_dimen.dart';
import 'package:weather_app_sample/ui/views/home_view.dart';

class DimensManager {

  static DimensManager? _instance;


  late DimenHomeView _dimensHomeView;

  DimenHomeView get homeViewSize => _dimensHomeView;

  /// Constructor
  DimensManager._() {
    _calculatorLanguage();
    _initializeDimens();
  }

  factory DimensManager() {
    return _instance ??= DimensManager._();
  }

  void _calculatorLanguage() {
    //TODO: Locale myLocale = Localizations.localeOf(context);
  }

  void _initializeDimens() {
    _dimensHomeView = DimenHomeView();
  }

  void calculatorRatio<T>(BuildContext context) {
    switch (T) {
      case HomeView:
        _dimensHomeView.calculatorRatio<T>(context);
        break;
    }
  }
}
