import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String firstName;
  final String lastName;

  User(
      this.id,
      this.username,
      this.firstName,
      this.lastName
      )
      : super([
    id,
    username,
    firstName,
    lastName
  ]);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'],
        json['username'],
        json['first_name'],
        json['last_name']
    );
  }

  factory User.copyAndEdit({@required User user, String username}) {
    return User(
        user.id,
        user.username,
        user.firstName,
        user.lastName,
    );
  }
}