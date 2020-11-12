part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends EventEvent {}

class Delete extends EventEvent {
  //final String id;
  final int event;
  final List<Event> events;

  //const Deleted({@required this.id});
  const Delete({@required this.event, this.events});

  @override
  List<Object> get props => [event, events];
  //List<Object> get props => [id];

  @override
  String toString() => 'Delete { event: $event, events: $events }';
//String toString() => 'Delete { id: $id }';
}

class Deleted extends EventEvent {
  //final String id;
  final int event;

  //const Deleted({@required this.id});
  const Deleted({@required this.event});

  @override
  List<Object> get props => [event];
  //List<Object> get props => [id];

  @override
  String toString() => 'Deleted { event: $event }';
//String toString() => 'Deleted { id: $id }';
}

class Updated extends EventEvent {
  final List<Event> events;

  const Updated(this.events);

  @override
  List<Object> get props => [events];
}
