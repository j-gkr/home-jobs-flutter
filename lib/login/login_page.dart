import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterhomejobs/bloc/authentication_bloc.dart';
import 'package:flutterhomejobs/bloc/login_bloc.dart';
import 'package:flutterhomejobs/login/login_form.dart';
import 'package:flutterhomejobs/repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;
  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeJobs'),
      ),
      body: BlocProvider(
        builder: (context) {

          return LoginBloc(
            userRepository: userRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          );
        },
        child: LoginForm(),
      ),
    );
  }
}