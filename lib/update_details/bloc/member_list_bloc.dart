import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:air_event/update_details/bloc/bloc.dart';
import 'package:air_event/update_details/bloc/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class MemberListBloc extends Bloc<MemberListEvent, MemberListState> {
  final http.Client httpClient;

  MemberListBloc({@required this.httpClient}) : super(MemberListInitial());

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
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return MemberList(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
