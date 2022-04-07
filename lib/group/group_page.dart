import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterhomejobs/bloc/group_data_bloc.dart';
import 'package:flutterhomejobs/bloc/group_data_event.dart';
import 'package:flutterhomejobs/bloc/group_data_state.dart';
import 'package:flutterhomejobs/common/app_drawer.dart';
import 'package:flutterhomejobs/common/loading_indicator.dart';
import 'package:flutterhomejobs/group/group_list_item_widget.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState  extends State<GroupPage> {
  Future<Null> _handleRefresh() async {
    BlocProvider.of<GroupDataBloc>(context).dispatch(ReloadGroupData());
    print("refresh");
    return null;
  }

  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    var t = BlocProvider.of<GroupDataBloc>(context);
    t.dispatch(ReloadGroupData());
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<GroupDataBloc, GroupDataState>(
      builder: (context, state) {
        if (state is GroupDataUninitialized) {
          BlocProvider.of<GroupDataBloc>(context)
              .dispatch(FetchGroupData());

          return Center(
            child: LoadingIndicator(),
          );
        }

        var children = new List<Widget>();

        if (state is GroupDataError) {
          children.add(Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error, color: Colors.red, size: 48),
                  Text('Fehler beim Abfragen der Gruppen!'),
                  Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  RaisedButton(
                    child: Text('Neu laden'),
                    onPressed: _handleRefresh,
                  )
                ]),
          ));
        } else if (state is GroupDataLoaded) {
          if (state.items.isEmpty) {
            children.add(Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check, color: Colors.green, size: 48),
                    Text('Keine Gruppen vorhanden!'),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    RaisedButton(
                      child: Text('Neu laden'),
                      onPressed: _handleRefresh,
                    )
                  ]),
            ));
          } else {
            children.add(Flexible(
                child: SafeArea(
                    child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            padding: new EdgeInsets.symmetric(vertical: 8.0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index >= state.items.length) {
                                return null;
                              }

                              return GroupListItemWidget(
                                groupRepository: BlocProvider.of<GroupDataBloc>(context).groupRepository,
                                item: state.items[index],
                                groupDataBloc: BlocProvider.of<GroupDataBloc>(context),
                              );
                            },
                            itemCount: state.items.length)))));
          }
        }

        /*
        _onCreatePressed() {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeCreatePage(BlocProvider.of<EmployeesDataBloc>(context).employeeRepository, BlocProvider.of<EmployeesDataBloc>(context))));
        }*/

        return Scaffold(
          appBar: AppBar(
            title: Text('Gruppen'),
          ),
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
          drawer: AppDrawer(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              return;
            },
            label: Text('Gruppe erstellen'),
            icon: Icon(Icons.add),
            backgroundColor: Colors.amber[800],
          ),
        );
      },
    );
  }
}