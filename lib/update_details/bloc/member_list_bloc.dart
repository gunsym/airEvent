import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:air_event/update_details/bloc/bloc.dart';
import 'package:air_event/update_details/models/models.dart';
import 'package:members_repository/members_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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
    print('hi2');
    if (event is MemberListFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MemberListInitial) {
          final memberList = await _fetchMemberList(0, 20);
          yield MemberListSuccess(memberList: memberList, hasReachedMax: false);
          return;
        }
        if (currentState is MemberListSuccess) {
          final memberList =
              await _fetchMemberList(currentState.memberList.length, 20);
          yield memberList.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MemberListSuccess(
                  memberList: currentState.memberList + memberList,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield MemberListFailure();
      }
    }
  }

  bool _hasReachedMax(MemberListState state) =>
      state is MemberListSuccess && state.hasReachedMax;

  Future<List<MemberList>> _fetchMemberList(int startIndex, int limit) async {
    print('hi');
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
    return null;
  }
}
