import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../services/app_init_service.dart';

class DemoPageController extends GetxController {
  late final AppLifecycleListener listener;
  late AppLifecycleState? state;

  @override
  void onInit() {
    state = SchedulerBinding.instance.lifecycleState;
    listener = AppLifecycleListener(
      onShow: () => logger.d('onShow'),
      onResume: () => logger.d('resume'),
      onHide: () => logger.d('hide'),
      onInactive: () => logger.d('inactive'),
      onPause: () => logger.d('pause'),
      onDetach: () => logger.d('detach'),
      onRestart: () => logger.d('restart'),
// This fires for each state change. Callbacks above fire only for
// specific state transitions.
      onStateChange: (value) => logger.d('state: $value'),
    );
    super.onInit();
  }
}
