import 'package:flutterhomejobs/common/app_drawer.dart';
import 'package:flutterhomejobs/common/loading_indicator.dart';
import 'package:flutterhomejobs/model/user.dart';
import 'package:flutterhomejobs/util/LifecycleEventHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {

  final User me;

  const HomePage({Key key, this.me}) : super(key: key);

  @override
  _HomePageState  createState() => _HomePageState();
}

class _HomePageState  extends State<HomePage> {

  static LifecycleEventHandler eventHandler;
  final storage = new FlutterSecureStorage();

  /// Reload Data if the dashboard data is suspended and resume or if theire was some connection errors
  @override
  void initState() {
    super.initState();

    eventHandler = LifecycleEventHandler(resumeCallBack: () {
      print("resume");
      return;
    },
        suspendingCallBack: () {
          print("suspend");
          return;
        });

    WidgetsBinding.instance.addObserver(eventHandler);
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(eventHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}