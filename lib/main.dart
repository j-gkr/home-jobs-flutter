import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/authentication_bloc.dart';
import 'package:flutterhomejobs/bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/group_data_bloc.dart';
import 'package:flutterhomejobs/bloc/navigation_bloc.dart';
import 'package:flutterhomejobs/bloc/navigation_event.dart';
import 'package:flutterhomejobs/bloc/navigation_state.dart';
import 'package:flutterhomejobs/common/loading_indicator.dart';
import 'package:flutterhomejobs/group/group_details_page.dart';
import 'package:flutterhomejobs/group/group_page.dart';
import 'package:flutterhomejobs/home/home_page.dart';
import 'package:flutterhomejobs/login/login_page.dart';
import 'package:flutterhomejobs/repository/group_repository.dart';
import 'package:flutterhomejobs/repository/payment_repository.dart';
import 'package:flutterhomejobs/repository/user_repository.dart';
import 'package:flutterhomejobs/splash/splash_page.dart';
import 'package:flutterhomejobs/util/VarContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print(message);
  return null;
}

var startPage = VarContainer(startPage: 'home');

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  //Intl.defaultLocale = 'de_DE';

  final userRepository = UserRepository();
  final groupRepository = GroupRepository(userRepository);
  final paymentRepository = PaymentRepository(userRepository);
  final AuthenticationBloc authenticationBloc = AuthenticationBloc(userRepository: userRepository);

  runZoned<void>(() {
    return runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(builder: (BuildContext content) => NavigationBloc(authenticationBloc, startPage)),
          BlocProvider<AuthenticationBloc>(builder: (BuildContext content) => authenticationBloc),
          BlocProvider<LoginBloc>(builder: (BuildContext content) => LoginBloc(authenticationBloc: authenticationBloc, userRepository: userRepository)),
          BlocProvider<GroupDataBloc>(builder: (BuildContext context) => GroupDataBloc(groupRepository: groupRepository)),
          BlocProvider<GroupBottomNavigationBloc>(builder: (BuildContext context) => GroupBottomNavigationBloc(PaymentRepository(userRepository)))
        ],
        child: App(userRepository: userRepository, groupRepository: groupRepository, paymentRepository: paymentRepository),
      ),
    );
  },
  );
}

class App extends StatefulWidget {
  final UserRepository userRepository;
  final GroupRepository groupRepository;
  final PaymentRepository paymentRepository;

  App({
    Key key,
    @required this.userRepository,
    @required this.groupRepository,
    @required this.paymentRepository,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HomeJobs",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('de'),
      ],
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          Future<bool> _onBackPressed() {
            return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Möchten Sie die App wirklich schließen?'),
                content: new Text(''),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Nein'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  FlatButton(
                    child: Text('Ja'),
                    onPressed: () => Navigator.pop(context, true),
                  )
                ],
              ),

            );
          }

          if (state is GroupPageState) {
            return WillPopScope(
              onWillPop: _onBackPressed,
              child: GroupPage()
            );
          }

          if (state is HomePageState) {
            return WillPopScope(
                onWillPop: _onBackPressed,
                child: HomePage()
            );
          }

          if (state is LoginPageState) {
            return WillPopScope(
                onWillPop: _onBackPressed,
                child: LoginPage(userRepository: widget.userRepository)
            );
          }

          if (state is LoadingIndicatorState) {
            return LoadingIndicator();
          }

          if (state is SplashPageState) {
            return SplashPage();
          }

          return SplashPage();
        },
      ),
    );
  }

  void goToPage(int id)
  {
    //Navigator.of(context).pop();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageDetailPage(id)));
    BlocProvider.of<NavigationBloc>(context).dispatch(HomePageDetailEvent(item: id));
  }

  @override
  void initState() {
    super.initState();
  }
}