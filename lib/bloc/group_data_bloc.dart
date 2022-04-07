import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/group_data_event.dart';
import 'package:flutterhomejobs/bloc/group_data_state.dart';
import 'package:flutterhomejobs/repository/group_repository.dart';
import 'package:meta/meta.dart';

class GroupDataBloc extends Bloc<GroupDataEvent, GroupDataState> {
  final GroupRepository groupRepository;

  GroupDataBloc({@required this.groupRepository});

  @override
  GroupDataState get initialState => GroupDataUninitialized();

  @override
  Stream<GroupDataState> mapEventToState(GroupDataEvent event) async* {
    try {
      if (event is FetchGroupData && !_hasReachedMax(currentState)) {
        final items = await this.groupRepository.getGroups();

        yield GroupDataLoaded(items: items, hasReachedMax: true);
      }

      if (event is ReloadGroupData) {
        yield GroupDataUninitialized();
      }
    } catch(_) {
      print(_.toString());
      yield GroupDataError();
    }
  }

  bool _hasReachedMax(GroupDataState state) => state is GroupDataLoaded && state.hasReachedMax;
}