import 'package:flutter/material.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/group_data_bloc.dart';
import 'package:flutterhomejobs/group/group_details_page.dart';
import 'package:flutterhomejobs/model/group.dart';
import 'package:flutterhomejobs/repository/group_repository.dart';
import 'package:flutterhomejobs/repository/payment_repository.dart';

class GroupListItemWidget extends StatelessWidget {
  final Group item;
  final GroupRepository groupRepository;
  final GroupDataBloc groupDataBloc;

  const GroupListItemWidget({Key key, @required this.groupRepository, @required this.item, @required this.groupDataBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name ?? "n/a", style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Monatliches Budget: ' + item.budget.toString() ?? "n/a", textAlign: TextAlign.start),
          ]
      ),
      isThreeLine: false,
      dense: true,
      onTap: () {
        //BlocProvider.of<NavigationBloc>(context).dispatch(GroupDetailsEvent(item: item));
        Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetailsPage(this.groupRepository, item)));
      },
    );
  }
}