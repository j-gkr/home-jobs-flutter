import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/authentication_bloc.dart';
import 'package:flutterhomejobs/bloc/authentication_event.dart';
import 'package:flutterhomejobs/bloc/authentication_state.dart';
import 'package:flutterhomejobs/bloc/navigation_event.dart';
import 'package:flutterhomejobs/bloc/navigation_state.dart';
import 'package:flutterhomejobs/util/VarContainer.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final AuthenticationBloc authenticationBloc;
  final VarContainer pageControl;

  StreamSubscription otherBlocSubscription;

  @override
  NavigationState get initialState => LoginPageState();

  NavigationBloc(this.authenticationBloc, this.pageControl) {
    this.otherBlocSubscription = this.authenticationBloc.state.listen((state) {
      if (state is AuthenticationUninitialized) {
        this.dispatch(SplashPageEvent());
      }

      if (state is AuthenticationAuthenticated) {
        if (this.pageControl.startPage == 'detail') {
          this.dispatch(HomePageDetailEvent(item: this.pageControl.id));
          this.pageControl.startPage = 'home';
          this.pageControl.id = null;
        } else {
          this.dispatch(HomePageEvent());
        }
      }

      if (state is AuthenticationUnauthenticated) {
        this.dispatch(LoginPageEvent());
      }
      if (state is AuthenticationLoading) {
        this.dispatch(LoadingIndicatorEvent());
      }
    });

    this.authenticationBloc.dispatch(AppStarted());
  }

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is HomePageEvent && this.authenticationBloc.currentState is AuthenticationAuthenticated) {
      yield HomePageState();
    }

    if (event is GroupPageEvent && this.authenticationBloc.currentState is AuthenticationAuthenticated) {
      yield GroupPageState();
    }

    if (event is GroupDetailsEvent && this.authenticationBloc.currentState is AuthenticationAuthenticated) {
      yield GroupDetailsState();
    }

    if (event is HomePageDetailEvent) {
      yield HomePageDetailState(event.item);
    }

    if (event is LoadingIndicatorEvent) {
      yield LoadingIndicatorState();
    }

    if (event is LoginPageEvent) {
      yield LoginPageState();
    }

    if (event is SplashPageEvent) {
      yield SplashPageState();
    }
  }

  @override
  void dispose() {
    otherBlocSubscription.cancel();
    super.dispose();
  }
}