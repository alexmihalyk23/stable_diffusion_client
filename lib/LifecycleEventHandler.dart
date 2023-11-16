import 'package:flutter/material.dart';

final lifecycleEventHandler = LifecycleEventHandler._();

class LifecycleEventHandler extends WidgetsBindingObserver {
  var inBackground = true;

  LifecycleEventHandler._();

  init() {
    WidgetsBinding.instance.addObserver(lifecycleEventHandler);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        inBackground = false;
        print('in foreground');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        inBackground = true;
        print('in background');
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }
}