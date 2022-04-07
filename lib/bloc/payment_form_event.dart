import 'package:equatable/equatable.dart';
import 'package:flutterhomejobs/model/payment.dart';

abstract class PaymentFormEvent extends Equatable {
  PaymentFormEvent([List props = const []]) : super(props);
}

class SubmitButtonPressed extends PaymentFormEvent {
  final Payment model;
  final bool editMode;

  SubmitButtonPressed(this.model, this.editMode);

  @override
  String toString() =>
      'Payment SubmitButtonPressed {$model}';
}