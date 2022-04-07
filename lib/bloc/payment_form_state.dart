import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PaymentFormState extends Equatable {
  PaymentFormState([List props = const []]) : super(props);
}

class PaymentFormInitial extends PaymentFormState {
  @override
  String toString() => 'PaymentFormInitial';
}

class PaymentLoading extends PaymentFormState {
  @override
  String toString() => 'PaymentLoading';
}

class PaymentFinished extends PaymentFormState {
  @override
  String toString() => 'PaymentFinished';
}

class PaymentFailure extends PaymentFormState {
  final String error;

  PaymentFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'PaymentFailure { error: $error }';
}
