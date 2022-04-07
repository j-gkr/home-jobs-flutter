import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/payment_form_bloc.dart';
import 'package:flutterhomejobs/payment/payment_form.dart';
import 'package:flutterhomejobs/repository/payment_repository.dart';


class PaymentCreatePage extends StatelessWidget {

  final int walletId;
  final PaymentRepository paymentRepository;
  final GroupBottomNavigationBloc groupBottomNavigationBloc;

  PaymentCreatePage(this.paymentRepository, this.groupBottomNavigationBloc, this.walletId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ausgabe erstellen '),
      ),
      body: BlocProvider(
        builder: (context) {
          return PaymentFormBloc(walletId, paymentRepository: this.paymentRepository, groupBottomNavigationBloc: this.groupBottomNavigationBloc);
        },
        child: PaymentForm(),
      ),
    );
  }
}