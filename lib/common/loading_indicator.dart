import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
              Text('Lade Daten...', style: TextStyle(color: Colors.white))
            ]),
      ));
}