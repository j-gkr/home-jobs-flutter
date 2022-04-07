import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/payment_form_bloc.dart';
import 'package:flutterhomejobs/bloc/payment_form_event.dart';
import 'package:flutterhomejobs/bloc/payment_form_state.dart';
import 'package:flutterhomejobs/common/loading_indicator.dart';
import 'package:flutterhomejobs/model/payment.dart';
import 'package:flutterhomejobs/model/payment_category.dart';
import 'package:flutterhomejobs/util/ExtendedDropDownFormField.dart';
import 'package:validators/validators.dart';
import 'package:intl/intl.dart';

class PaymentForm extends StatefulWidget {
  final Payment editData;

  PaymentForm({this.editData}) : super();

  @override
  State<PaymentForm> createState() => null != editData
      ? _PaymentFormState(model: editData)
      : _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _eNameCtrl = TextEditingController();
  final _eAmountCtrl = TextEditingController();
  final _eDescriptionCtrl = TextEditingController();
  final _ePaymentDateCtrl = TextEditingController();
  final _ePaymentCategoryCtrl = TextEditingController();
  PaymentCategory _pickedCategory;

  final _formKey = GlobalKey<FormState>();

  Payment model;

  _PaymentFormState({this.model}) {
    var format = DateFormat('yyyy-MM-dd');

    if (this.model != null) {
      this._eNameCtrl.text = this.model.name ?? '';
      this._eAmountCtrl.text = this.model.amount.toString() ?? '0';
      this._eDescriptionCtrl.text = this.model.description ?? '';
      this._ePaymentDateCtrl.text = format.format(this.model.paymentDate) ?? format.format(DateTime.now());
      this._ePaymentCategoryCtrl.text = this.model.paymentCategory.toString() ?? '';
      this._pickedCategory = this.model.paymentCategory;
    } else {
      this._ePaymentDateCtrl.text = format.format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    _onSubmitPressed() {
      if (_formKey.currentState.validate()) {
        if (this.model != null) {
          final Payment e = Payment.copyAndEdit(
              payment: this.model,
              name: this._eNameCtrl.value.text,
              amount: double.parse(this._eAmountCtrl.value.text.replaceAll(',', '.')),
              description: this._eDescriptionCtrl.value.text,
              paymentDate: DateTime.parse(this._ePaymentDateCtrl.value.text),
              paymentCategory: this._pickedCategory);

          BlocProvider.of<PaymentFormBloc>(context)
              .dispatch(SubmitButtonPressed(e, true));
        } else {
          final e = Payment(
              0,
              this._eNameCtrl.value.text,
              double.parse(this._eAmountCtrl.value.text.replaceAll(',', '.')),
              this._eDescriptionCtrl.value.text,
              DateTime.parse(this._ePaymentDateCtrl.value.text),
              this._pickedCategory);
          BlocProvider.of<PaymentFormBloc>(context)
              .dispatch(SubmitButtonPressed(e, false));
        }
      }
    }

    return BlocListener<PaymentFormBloc, PaymentFormState>(
      listener: (context, state) {
        if (state is PaymentFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is PaymentFinished) {
          Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Speichern war erfolgreich!'),
                backgroundColor: Colors.green,
              ));

          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        }
      },
      child: BlocBuilder<PaymentFormBloc, PaymentFormState>(
        bloc: BlocProvider.of<PaymentFormBloc>(context),
        builder: (
            BuildContext context,
            PaymentFormState state,
            ) {
          if (state is PaymentLoading) {
            return LoadingIndicator();
          }

          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Name'),
                            controller: _eNameCtrl,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Bitte einen Namen angeben';
                              }

                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: TextFormField(
                            decoration:
                            InputDecoration(labelText: 'Betrag'),
                            controller: _eAmountCtrl,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Bitte einen Betrag angeben.';
                              }

                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Beschreibung'),
                            controller: _eDescriptionCtrl,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Datum'),
                            controller: _ePaymentDateCtrl,
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: FutureBuilder(
                              future: BlocProvider.of<GroupBottomNavigationBloc>(context).paymentRepository.getCategories(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                switch(snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return CircularProgressIndicator();
                                  default:
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return Text('Es ist ein Fehler aufgetreten....');
                                    } else {
                                      final source = snapshot.data.map((data) {
                                        final PaymentCategory a = data;

                                        return {
                                          "display": a.name,
                                          "value": a,
                                        };
                                      }).toList();

                                      return
                                        ExtendedDropDownFormField(
                                          titleText: 'Kategorie',
                                          hintText: 'Bitte wählen Sie eine Kategorie',
                                          value: _pickedCategory,
                                          onSaved: (value) {
                                            setState(() {
                                              _pickedCategory = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _pickedCategory = value;
                                            });
                                          },
                                          dataSource: source,
                                          textField: 'display',
                                          valueField: 'value',
                                          onRender: (item, valueField, textField) {
                                            return DropdownMenuItem<dynamic>(
                                              value: item[valueField],
                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(item[textField]),
                                                  ]),
                                            );
                                          },
                                        );
                                  }
                              }
                            }
                          )
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
                            child: RaisedButton(
                              color: Colors.amber[800],
                              onPressed: state is! PaymentLoading
                                  ? _onSubmitPressed
                                  : null,
                              child: Text('Speichern', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        Container(
                          child: state is PaymentLoading
                              ? CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.red))
                              : null,
                        ),
                      ],
                    ),
                  )));
        },
      ),
    );
  }
}