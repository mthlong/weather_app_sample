import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/base_view_model.dart';
import '../shared/colors.dart';
import '../shared/dimens/base_dimen.dart';

class BaseView extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  BaseViewState createState() => BaseViewState();
}
class BaseViewState<V extends BaseView, VM extends BaseViewModel,
D extends BaseDimens> extends State<V> with WidgetsBindingObserver {
  late final VM viewModel;
  late final D viewSize;

  @override
  void initState() {
    super.initState();
    createDimens();
    createViewModel();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) => onBuildCompleted());
  }

  void createDimens() {
    // Override for create Dimens
  }

  void calculatorSizeForOtherWidget() {}

  void createViewModel() {
    // Override for create ViewModel each View
  }

  bool isNeedReBuildByOtherViewModel() {
    return true;
  }

  void onBuildCompleted() {
    viewModel.onBuildComplete(
      isNeedReBuildByOtherViewModel: isNeedReBuildByOtherViewModel(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(),
      child: ChangeNotifierProvider<VM>(
        create: (_) => viewModel,
        child: Selector<VM, bool>(
          selector: (_, viewModel) => viewModel.checkReCalculatorSize(
              allowReCalculatorSize:
              viewSize.checkAllowReCalculatorSize(context)),
          shouldRebuild: (prev, next) => next == true,
          builder: (_, calculatorSize, __) {
            if (calculatorSize) {
              viewSize.calculatorRatio<V>(context);
              calculatorSizeForOtherWidget();
            }
            return Selector<VM, bool>(
              selector: (_, viewModel) => viewModel.isShowLoading,
              child: buildView(context),
              builder: (_, isShowLoading, child) {
                return Selector<VM, bool>(
                  selector: (_, viewModel) => !Navigator.canPop(context),
                  builder: (_, isLockScreenOff, __) {
                    return Stack(
                      children: [
                        AbsorbPointer(
                          // Disable click when loading ...
                          absorbing: isShowLoading || isLockScreenOff,
                          child: child ?? const SizedBox.shrink(),
                        ),
                        if (isShowLoading)
                          Positioned.fill(
                            child: buildLoading(),
                          ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    return !Navigator.canPop(context);
  }

  AppBar? buildAppBar() {
    return null;
  }

  Widget? buildBottomSheet() {
    return null;
  }

  /// Override for each view ...
  Widget buildView(BuildContext context) {
    return Container();
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(
          HexColors.primaryColor,
        ),
      ),
    );
  }
}