import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// enum NavigationEvent {SplashPage, LoginPage, HomePage, HomePageDetail, CallStatsPage, LoadingIndicator}

abstract class NavigationEvent extends Equatable {
  NavigationEvent([List props = const []]) : super(props);
}

class SplashPageEvent extends NavigationEvent {}
class LoginPageEvent extends NavigationEvent {}
class HomePageEvent extends NavigationEvent {}
class GroupPageEvent extends NavigationEvent {}
class GroupDetailsEvent extends NavigationEvent {}
class HomePageDetailEvent extends NavigationEvent {
  final int item;
  HomePageDetailEvent({
    @required this.item
  }) : super([item]);
}

class CallStatsPageEvent extends NavigationEvent {}
class EmployeeListPageEvent extends NavigationEvent {}
class LoadingIndicatorEvent extends NavigationEvent {}
class EventsListEvent extends NavigationEvent {}
class SettingPageEvent extends NavigationEvent {}
class FaqPageEvent extends NavigationEvent {}