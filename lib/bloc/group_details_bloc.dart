import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/group_details_event.dart';
import 'package:flutterhomejobs/bloc/group_details_state.dart';
import 'package:flutterhomejobs/repository/group_repository.dart';
import 'package:meta/meta.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  final GroupRepository groupRepository;

  GroupDetailsBloc({@required this.groupRepository});

  @override
  GroupDetailsState get initialState => GroupDetailsUninitialized();

  @override
  Stream<GroupDetailsState> mapEventToState(GroupDetailsEvent event) async* {
    try {
      if (event is FetchGroupDetails) {
        final group = await this.groupRepository.getGroup(event.group.id);

        yield GroupDetailsLoaded(group: group);
      }

      if (event is ReloadGroupDetails) {
        yield GroupDetailsUninitialized();
      }
    } catch(_) {
      print(_.toString());
      yield GroupDetailsError();
    }
  }
}