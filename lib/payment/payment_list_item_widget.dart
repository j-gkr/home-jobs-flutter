import 'package:flutter/material.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/model/payment.dart';
import 'package:flutterhomejobs/payment/payment_detail_page.dart';
import 'package:flutterhomejobs/repository/payment_repository.dart';

class PaymentListItemWidget extends StatelessWidget {
  final Payment item;
  final PaymentRepository paymentRepository;
  final GroupBottomNavigationBloc groupBottomNavigationBloc;
  final int walletId;

  const PaymentListItemWidget({Key key, @required this.paymentRepository, @required this.item, @required this.groupBottomNavigationBloc, this.walletId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Icon> iconMapping = new Map();

    iconMapping['Lebensmittel'] = Icon(Icons.local_dining, color: Colors.white);
    iconMapping['Wohnen'] = Icon(Icons.location_city, color: Colors.white);
    iconMapping['Elektronik'] = Icon(Icons.videogame_asset, color: Colors.white);
    iconMapping['Nebenkosten'] = Icon(Icons.attach_money, color: Colors.white);
    iconMapping['Reparatur'] = Icon(Icons.build, color: Colors.white);
    iconMapping['Geschenke'] = Icon(Icons.cake, color: Colors.white);
    iconMapping['Haushalt'] = Icon(Icons.home, color: Colors.white);
    iconMapping['Freizeit'] = Icon(Icons.directions_run, color: Colors.white);
    iconMapping['Auto'] = Icon(Icons.directions_car, color: Colors.white);

    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(item.name ?? "n/a", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(item.amount.toStringAsFixed(2) + ' €', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
        ],
      ) ,
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(item.paymentCategory.name ?? "n/a", textAlign: TextAlign.start),
          ]
      ),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 44,
          maxHeight: 44,
        ),
        child: Container(
          child: iconMapping[item.paymentCategory.name] ?? Icon(Icons.shopping_basket, color: Colors.white),
          decoration: new BoxDecoration(
            color: hexToColor(this.item.paymentCategory.color),
            shape: BoxShape.circle
          ),
        ),
      ),
      isThreeLine: false,
      dense: true,
      onTap: () {
        //BlocProvider.of<NavigationBloc>(context).dispatch(GroupDetailsEvent(item: item));
        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetailPage(this.item, this.walletId, this.paymentRepository, this.groupBottomNavigationBloc)));
      },
    );
  }

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}