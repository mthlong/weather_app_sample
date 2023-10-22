import 'package:flutter/cupertino.dart';

class BaseDimens {
  BuildContext? usedContext;


  Orientation _orientation = Orientation.portrait;

  Orientation get orientation => _orientation;

  double fullWidth = 0;

  double fullHeight = 0;

  double textScaleFactor = 0;

  void calculatorRatio<T>(BuildContext context) {

    _orientation = MediaQuery.of(context).orientation;

    fullWidth = MediaQuery.of(context).size.width;
    fullHeight = MediaQuery.of(context).size.height;
    textScaleFactor = MediaQuery.of(context).textScaleFactor;

    initialDimens<T>();
  }

  //Size determination for each screen
  void initialDimens<T>() {}

  bool checkAllowReCalculatorSize(BuildContext context) {
    if (fullWidth == 0 || fullHeight == 0 || usedContext == null) {
      usedContext = context;
      return true;
    }
    final mediaQueryData = MediaQuery.of(context);
    final newWidth = mediaQueryData.size.width;
    final newHeight = mediaQueryData.size.height;
    final newTextScaleFactor = mediaQueryData.textScaleFactor;
    final newOrientation = mediaQueryData.orientation;
    final result = newWidth != fullWidth ||
        newHeight != fullHeight ||
        newTextScaleFactor != textScaleFactor ||
        newOrientation != _orientation;
    if (result) {
      return true;
    }
    return false;
  }
}