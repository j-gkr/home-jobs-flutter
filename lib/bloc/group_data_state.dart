import 'package:equatable/equatable.dart';
import 'package:flutterhomejobs/model/group.dart';

abstract class GroupDataState extends Equatable {
  GroupDataState([List props = const []]) : super(props);
}

class GroupDataUninitialized extends GroupDataState {
  @override
  String toString() => 'GroupDataUninitialized';
}

class GroupDataError extends GroupDataState {
  @override
  String toString() => 'GroupDataError';
}

class GroupDataLoaded extends GroupDataState {
  final List<Group> items;
  final bool hasReachedMax;

  GroupDataLoaded({
    this.items,
    this.hasReachedMax,
  }) : super([items, hasReachedMax]);

  GroupDataLoaded copyWith({
    List<Group> items,
    bool hasReachedMax,
  }) {
    return GroupDataLoaded(items: items ?? this.items, hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() => 'GroupDataLoaded { items: ${items.length}, hasReachedMax: $hasReachedMax }';
}