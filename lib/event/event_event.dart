part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends EventEvent {}

class Updated extends EventEvent {
  final List<Event> events;

  const Updated(this.events);

  @override
  List<Object> get props => [events];
}
