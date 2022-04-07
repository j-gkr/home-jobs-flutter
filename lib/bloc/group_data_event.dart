import 'package:equatable/equatable.dart';

abstract class GroupDataEvent extends Equatable {}

class FetchGroupData extends GroupDataEvent {
  @override
  String toString() => 'Fetch Group Data Items';
}

class ReloadGroupData extends GroupDataEvent {

  @override
  String toString() => 'Reload Call Group Items';
}