import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {}

class LoginPageState extends NavigationState {}
class SplashPageState extends NavigationState {}
class HomePageState extends NavigationState {}
class GroupPageState extends NavigationState {}
class GroupDetailsState extends NavigationState {}
class CallStatsPageState extends NavigationState {}
class LoadingIndicatorState extends NavigationState {}
class EmployeeListPageState extends NavigationState {}
class HomePageDetailState extends NavigationState {
  final int item;
  HomePageDetailState(this.item);
}
class EventsListPageState extends NavigationState {}
class SettingPageState extends NavigationState {}
class FaqPageState extends NavigationState {}