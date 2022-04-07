import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_event.dart';
import 'package:flutterhomejobs/bloc/payment_form_bloc.dart';
import 'package:flutterhomejobs/common/loading_indicator.dart';
import 'package:flutterhomejobs/model/payment.dart';
import 'package:flutterhomejobs/model/token.dart';
import 'package:flutterhomejobs/payment/payment_form.dart';
import 'package:flutterhomejobs/repository/payment_repository.dart';


class PaymentDetailPage extends StatefulWidget {

  final Payment item;
  final int walletId;
  final PaymentRepository paymentRepository;
  final GroupBottomNavigationBloc groupBottomNavigationBloc;

  PaymentDetailPage(this.item, this.walletId, this.paymentRepository, this.groupBottomNavigationBloc);

  @override
  _PaymentDetailPageState createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {

  Future<Payment> item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ausgabe: ' + widget.item.name),
        actions: <Widget>[
          // Löschen nur für Haupt Accounts
          FutureBuilder(
              future: this.widget.paymentRepository.userRepository.getToken(),
              builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container();
                  default:
                    if (snapshot.hasError) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                                children: <Widget>[
                                  Icon(Icons.error, color: Colors.red, size: 48),
                                  Text('Fehler beim Abfragen der Ausgabe!'),
                                  Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                                ])
                          ]
                      );
                    }

                      return IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            return showDialog(context: context, builder: (context) => AlertDialog(
                              title: Text('Bestätigen'),
                              content: new Text('Möchten Sie die Ausgabe wirklich löschen?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Nein'),
                                  onPressed: () {
                                    print('no');
                                    Navigator.pop(context, false);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Ja'),
                                  onPressed: () {
                                    this.item.then((value) {
                                      this.widget.paymentRepository.deletePayment(value).then((value) {
                                        this.widget.groupBottomNavigationBloc.dispatch(PaymentGroupBottomNavigation());
                                        Navigator.pop(context, false);
                                        Navigator.pop(context, false);
                                      });
                                    });
                                  },
                                ),
                              ],
                            )
                            );
                          }
                      );
                    return Container();
                }
              }),

        ],
      ),
      body: BlocProvider(
        builder: (context) {
          return PaymentFormBloc(this.widget.walletId, paymentRepository: this.widget.paymentRepository, groupBottomNavigationBloc: this.widget.groupBottomNavigationBloc);
        },
        //   child: EmployeeForm(editData: this.widget.item),
        child: FutureBuilder(
            future: this.item,
            builder: (BuildContext context, AsyncSnapshot<Payment> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return LoadingIndicator();
                default:
                  return PaymentForm(editData: snapshot.data);
              }

            }),
      ),
    );
  }

  @override
  void initState() {
    this.item = this.widget.paymentRepository.getPayment(this.widget.item.id);
    super.initState();
  }
}