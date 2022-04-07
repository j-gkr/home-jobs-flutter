import 'package:flutter/material.dart';

class MemberPage extends StatefulWidget {

  const MemberPage({Key key}) : super(key: key);

  @override
  _MemberPageState  createState() => _MemberPageState();
}

class _MemberPageState  extends State<MemberPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}