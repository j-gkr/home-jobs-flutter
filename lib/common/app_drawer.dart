import 'package:flutterhomejobs/bloc/authentication_bloc.dart';
import 'package:flutterhomejobs/bloc/authentication_event.dart';
import 'package:flutterhomejobs/bloc/navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/navigation_event.dart';
import 'package:flutterhomejobs/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Expanded(
                  child: new Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Angemeldet als: ' + UserRepository.lastUsername, style: TextStyle(color: Colors.white), maxLines: 2)
                    ),
                  ),
                )
              ],
            ),
            //child:
            decoration: BoxDecoration(
               color: Colors.blue,
                //image: DecorationImage(image: AssetImage('assets/images/starbuero_drawer_background.png'))
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pop();
              BlocProvider.of<NavigationBloc>(context).dispatch(HomePageEvent());
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Gruppen'),
            onTap: () {
              Navigator.of(context).pop();
              BlocProvider.of<NavigationBloc>(context).dispatch(GroupPageEvent());
            },
          ),

          Divider(),

          /*
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Einstellungen'),
            enabled: true,
            onTap: () {
              Navigator.of(context).pop();
              BlocProvider.of<NavigationBloc>(context).dispatch(SettingPageEvent());
            },
          ),*/
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Abmelden'),
            onTap: () {
              Navigator.of(context).pop();
              BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedOut());
            },
          )
        ],
      ),
    );
  }
}