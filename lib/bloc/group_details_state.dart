import 'package:equatable/equatable.dart';
import 'package:flutterhomejobs/model/group.dart';

abstract class GroupDetailsState extends Equatable {
  GroupDetailsState([List props = const []]) : super(props);
}

class GroupDetailsUninitialized extends GroupDetailsState {
  @override
  String toString() => 'GroupDetailsUninitialized';
}

class GroupDetailsError extends GroupDetailsState {
  @override
  String toString() => 'GroupDetailsError';
}

class GroupDetailsLoaded extends GroupDetailsState {
  final Group group;

  GroupDetailsLoaded({
    this.group,
  }) : super([group]);

  GroupDetailsLoaded copyWith({
    Group group,
  }) {
    return GroupDetailsLoaded(group: group);
  }

  @override
  String toString() => 'GroupDetailsLoaded { group: ${group.toString()} }';
}