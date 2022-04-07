import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/model/token.dart';
import 'package:meta/meta.dart';
import 'package:flutterhomejobs/bloc/authentication_state.dart';
import 'package:flutterhomejobs/repository/user_repository.dart';

import 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository}): assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      final Token token = await userRepository.getToken();

      if (null != token && (token.isValid())) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      if (event.token.isValid()) {
        await userRepository.persistToken(event.token);
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}