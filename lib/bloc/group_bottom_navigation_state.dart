import 'package:equatable/equatable.dart';
import 'package:flutterhomejobs/model/payment.dart';

abstract class GroupBottomNavigationState extends Equatable {
  GroupBottomNavigationState([List props = const []]) : super(props);
}

class PaymentDataUninitialized extends GroupBottomNavigationState {
  @override
  String toString() => 'PaymentDataUninitialized';
}

class PaymentDataError extends GroupBottomNavigationState {
  @override
  String toString() => 'PaymentDataError';
}

class PaymentDataLoaded extends GroupBottomNavigationState {
  final List<Payment> items;

  PaymentDataLoaded({
    this.items,
  }) : super([items]);

  PaymentDataLoaded copyWith({
    List<Payment> items,
  }) {
    return PaymentDataLoaded(items: items ?? this.items);
  }

  @override
  String toString() => 'PaymentDataLoaded { items: ${items.length} }';

}

class MemberDataUninitialized extends GroupBottomNavigationState {
  @override
  String toString() => 'MemberDataUninitialized';
}

class GroupBottomNavigationError extends GroupBottomNavigationState {
  @override
  String toString() => 'GroupBottomNavigationError';
}