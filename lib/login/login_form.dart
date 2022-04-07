import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterhomejobs/bloc/login_bloc.dart';
import 'package:flutterhomejobs/bloc/login_event.dart';
import 'package:flutterhomejobs/bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController( );
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    this._usernameController.text = ''; // Neukunde
    this._passwordController.text = ''; // test1234

    _onLoginButtonPressed() {
      _loginBloc.dispatch(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        bloc: _loginBloc,
        builder: (
            BuildContext context,
            LoginState state,
            ) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Benutzername'),
                      controller: _usernameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Passwort'),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed:
                        state is! LoginLoading ? _onLoginButtonPressed : null,
                        child: Text('Anmelden'),
                      ),
                    ),
                    Container(
                      child: state is LoginLoading
                          ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                          : null,
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }
}