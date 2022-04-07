import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/authentication_bloc.dart';
import 'package:flutterhomejobs/bloc/authentication_event.dart';
import 'package:flutterhomejobs/bloc/login_event.dart';
import 'package:flutterhomejobs/bloc/login_state.dart';
import 'package:flutterhomejobs/repository/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        if (token.isValid()) {
          authenticationBloc.dispatch(LoggedIn(token: token));
        } else {
          yield LoginFailure(error: 'Login fehlgeschlagen!');
        }

        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}