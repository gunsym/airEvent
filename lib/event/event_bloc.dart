import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:members_repository/members_repository.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final MembersRepository membersRepository;
  StreamSubscription _eventSubscription;
  List myList;

  EventBloc({@required this.membersRepository}) : super(Loading());

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is FetchEvent) {
      yield* _mapLoadListToState();
    }
    if (event is Updated) {
      yield* _mapListUpdateToState(event);
    }
  }

  Stream<EventState> _mapLoadListToState() async* {
    try {
      _eventSubscription?.cancel();

      _eventSubscription = membersRepository.eventGroup('current').listen(
            (eventGroup) => add(Updated(eventGroup.events)),
          );
    } catch (e) {
      yield Failure();
    }
  }

  Stream<EventState> _mapListUpdateToState(Updated event) async* {
    yield Loaded(events: event.events);
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}
