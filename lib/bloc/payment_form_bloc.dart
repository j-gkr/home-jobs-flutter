import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_event.dart';
import 'package:flutterhomejobs/bloc/payment_form_event.dart';
import 'package:flutterhomejobs/bloc/payment_form_state.dart';
import 'package:flutterhomejobs/repository/payment_repository.dart';
import 'package:meta/meta.dart';

class PaymentFormBloc extends Bloc<PaymentFormEvent, PaymentFormState> {
  final PaymentRepository paymentRepository;
  final GroupBottomNavigationBloc groupBottomNavigationBloc;
  final int walletId;

  PaymentFormBloc(this.walletId, {@required this.paymentRepository, this.groupBottomNavigationBloc});

  PaymentFormState get initialState => PaymentFormInitial();

  @override
  Stream<PaymentFormState> mapEventToState(PaymentFormEvent event) async* {
    if (event is SubmitButtonPressed) {
      yield PaymentLoading();

      try {
        if (event.editMode) {
          await this.paymentRepository.patchPayment(event.model);
          if (null != this.groupBottomNavigationBloc) {
            this.groupBottomNavigationBloc.dispatch(PaymentGroupBottomNavigation());
          }
        } else {
          await this.paymentRepository.createPayment(event.model, walletId);
          if (null != this.groupBottomNavigationBloc) {
            this.groupBottomNavigationBloc.dispatch(PaymentGroupBottomNavigation());
          }
        }

        yield PaymentFinished();
      } catch (error) {
        yield PaymentFailure(error: error.toString());
      }
    }
  }
}