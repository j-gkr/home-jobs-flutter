import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterhomejobs/model/payment_category.dart';

class Payment extends Equatable {
  final int id;
  final String name;
  final double amount;
  final String description;
  final DateTime paymentDate;
  final PaymentCategory paymentCategory;

  Payment(
      this.id,
      this.name,
      this.amount,
      this.description,
      this.paymentDate,
      this.paymentCategory
      )
      : super([
    id,
    name,
    amount,
    description,
    paymentDate,
    paymentCategory
  ]);

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        json['id'],
        json['name'],
        json['amount'],
        json['description'],
        DateTime.parse(json['payment_date']).toLocal(),
        new PaymentCategory(json['payment_category']['id'], json['payment_category']['name'], json['payment_category']['color']) ,
    );
  }

  factory Payment.copyAndEdit({@required Payment payment, String name, double amount, String description, DateTime paymentDate, PaymentCategory paymentCategory}) {
    return Payment(
        payment.id,
        name ?? payment.name,
        amount ?? payment.amount,
        description ?? payment.description,
        paymentDate ?? payment.paymentDate,
        paymentCategory ?? payment.paymentCategory,
    );
  }
}