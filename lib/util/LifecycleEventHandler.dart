import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (null != suspendingCallBack) {
          await suspendingCallBack();
        }
        break;
      case AppLifecycleState.resumed:
        if (null != suspendingCallBack) {
          await resumeCallBack();
        }
        break;
    }
  }
}