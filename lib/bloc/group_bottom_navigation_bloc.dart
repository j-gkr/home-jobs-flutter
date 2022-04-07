import 'package:bloc/bloc.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_state.dart';
import 'package:flutterhomejobs/bloc/group_bottom_navigation_event.dart';
import 'package:flutterhomejobs/repository/payment_repository.dart';

class GroupBottomNavigationBloc extends Bloc<GroupBottomNavigationEvent, GroupBottomNavigationState> {

  final PaymentRepository paymentRepository;

  GroupBottomNavigationBloc(this.paymentRepository);

  @override
  GroupBottomNavigationState get initialState => PaymentDataUninitialized();

  @override
  Stream<GroupBottomNavigationState> mapEventToState(GroupBottomNavigationEvent event) async* {
    try {
      if (event is PaymentGroupBottomNavigation) {
        yield PaymentDataUninitialized();
      }

      if (event is PaymentDataLoading) {
        try {
          final items = await this.paymentRepository.getPayments(
              event.walletId);

          yield PaymentDataLoaded(items: items);
        } catch(_) {
          print(_.toString());
          yield PaymentDataError();
        }
      }

      if (event is MemberGroupBottomNavigation) {
        yield MemberDataUninitialized();
      }
    } catch(_) {
      print(_.toString());
      yield GroupBottomNavigationError();
    }
  }
}