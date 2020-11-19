part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class Loading extends EventState {}

class Loaded extends EventState {
  //final List<Item> items;
  final List<Event> events;

  const Loaded({@required this.events});

  @override
  List<Object> get props => [events];

  @override
  String toString() => 'Loaded { events: ${events.length} }';
}

class Failure extends EventState {}
