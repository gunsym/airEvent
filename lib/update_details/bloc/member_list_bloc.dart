import 'package:air_event/update_details/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:members_repository/members_repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:air_event/update_details/member_list.dart';

class MemberListBloc extends Bloc<MemberListEvent, MemberListState> {
  final MembersRepository membersRepository;
  StreamSubscription _familySubscription;

  MemberListBloc({@required this.membersRepository})
      : super(MemberListInitial());

  @override
  Stream<Transition<MemberListEvent, MemberListState>> transformEvents(
    Stream<MemberListEvent> events,
    TransitionFunction<MemberListEvent, MemberListState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<MemberListState> mapEventToState(MemberListEvent event) async* {
    final currentState = state;
    if (event is MemberListFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MemberListInitial) {
          //final memberLists = await
        }
      } catch (_) {}
    }
  }

  bool _hasReachedMax(MemberListState state) =>
      state is MemberListState && state.hasReachedMax;

  Future<List<MemberList>> _fetchMemberLists(int startIndex, int limit) async {
    try {
      //await Future<void>.delayed(Duration(milliseconds: 1500));
      _familySubscription?.cancel();
      _familySubscription =
          membersRepository.family('a@a.com').listen((family) {
        print(family);
        return family.members.map((e) {
          return MemberList(
            title: e.firstName,
          );
        }).toList();
      });
    } catch (_) {
      throw Exception('Network request failed. Please try again later.');
    }
  }
}
