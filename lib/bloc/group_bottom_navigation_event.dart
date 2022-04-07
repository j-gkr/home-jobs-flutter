import 'package:equatable/equatable.dart';

abstract class GroupBottomNavigationEvent extends Equatable {}

class PaymentGroupBottomNavigation extends GroupBottomNavigationEvent {
  @override
  String toString() => 'Payment Group Bottom Navigation';
}

class PaymentDataLoading extends GroupBottomNavigationEvent {
  final int walletId;

  PaymentDataLoading(this.walletId);

  @override
  String toString() => 'Payment Data Loading';
}

class MemberGroupBottomNavigation extends GroupBottomNavigationEvent {

  @override
  String toString() => 'Member Group Bottom Navigation';
}