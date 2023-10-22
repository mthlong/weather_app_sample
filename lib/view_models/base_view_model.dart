import 'package:flutter/cupertino.dart';

abstract class BaseViewModel extends ChangeNotifier {

  bool _isShowLoading = false;
  bool get isShowLoading => _isShowLoading;

  bool _isEmptyListeners = false;

  static final List<ChangeNotifier> _notifierList = [];
  List<ChangeNotifier> get notifierList =>
      _notifierList;

  BaseViewModel({bool isShowLoading = false}) {
    _isShowLoading = isShowLoading;
  }

  late BuildContext context;

  void setLoading({required bool isShow}) {
    _isShowLoading = isShow;
    updateCurrentUI();
  }

  void updateCurrentUI() {
    notifyListeners();
  }

  void updateUI() {
    if (!_isEmptyListeners) {
      notifyListeners();
    }
    if (_notifierList.isEmpty) return;
    for (ChangeNotifier notifier in _notifierList) {
      if (notifier != this) {
        notifier.notifyListeners();
      }
    }
  }

  // Function will check size device change
  bool checkReCalculatorSize({required bool allowReCalculatorSize}) {
    return allowReCalculatorSize;
  }

  void onInitViewModel(BuildContext context) {
    this.context = context;
  }

  void onBuildComplete({bool isNeedReBuildByOtherViewModel = true}) {
    if (isNeedReBuildByOtherViewModel && !_notifierList.contains(this)) {
      _notifierList.add(this);
    }
  }

  void removeNotifier() {
    if (_notifierList.contains(this)) {
      _notifierList.remove(this);
    }
  }

  void clearNotifier() {
    _notifierList.clear();
  }

  @override
  void dispose() {
    _isEmptyListeners = true;
    removeNotifier();
    super.dispose();
  }
}