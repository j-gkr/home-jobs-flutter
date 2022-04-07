import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Group extends Equatable {
  final int id;
  final String name;
  final double budget;
  final String street;
  final String housenumber;
  final String city;
  final String zip;
  final int walletId;

  Group(
      this.id,
      this.name,
      this.budget,
      this.street,
      this.housenumber,
      this.city,
      this.zip,
      this.walletId)
      : super([
    id,
    name,
    budget,
    street,
    housenumber,
    city,
    zip,
    walletId
  ]);

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        json['id'],
        json['name'],
        json['budget'],
        json['street'] ?? '',
        json['housenumber'] ?? '',
        json['city'] ?? '',
        json['zip'] ?? '',
        json['wallets'][0]['id'] ?? 0,
    );
  }

  factory Group.copyAndEdit({@required Group group, String name, double budget, String street, String housenumber, String city, String zip, int walletId}) {
    return Group(
        group.id,
        group.name,
        group.budget,
        group.street,
        group.housenumber,
        group.city,
        group.zip,
        group.walletId
    );
  }
}