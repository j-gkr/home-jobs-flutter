import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class PaymentCategory extends Equatable {
  final int id;
  final String name;
  final String color;

  PaymentCategory(
      this.id,
      this.name,
      this.color
      )
      : super([
    id,
    name,
    color
  ]);

  factory PaymentCategory.fromJson(Map<String, dynamic> json) {
    return PaymentCategory(
        json['id'],
        json['name'],
        json['color']
    );
  }

  factory PaymentCategory.copyAndEdit({@required PaymentCategory category, String name, String color}) {
    return PaymentCategory(
        category.id,
        name ?? category.name,
        color ?? category.color
    );
  }

  @override
  String toString() {
    return this.id.toString();
  }
}