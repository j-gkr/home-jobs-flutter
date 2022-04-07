import 'package:equatable/equatable.dart';
import 'package:flutterhomejobs/model/group.dart';

abstract class GroupDetailsEvent extends Equatable {}

class FetchGroupDetails extends GroupDetailsEvent {
  final Group group;

  FetchGroupDetails(this.group);

  @override
  String toString() => 'Fetch Group Details';
}

class ReloadGroupDetails extends GroupDetailsEvent {

  @override
  String toString() => 'Reload Group Details';
}