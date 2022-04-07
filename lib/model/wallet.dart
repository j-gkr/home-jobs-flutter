import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Wallet extends Equatable {
  final int id;
  final String name;

  Wallet(
      this.id,
      this.name
      )
      : super([
    id,
    name
  ]);

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
        json['id'],
        json['name']
    );
  }

  factory Wallet.copyAndEdit({@required Wallet wallet, String name}) {
    return Wallet(
        wallet.id,
        wallet.name
    );
  }
}