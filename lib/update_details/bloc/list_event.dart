part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends ListEvent {}

class Delete extends ListEvent {
  //final String id;
  final int member;
  final List<Member> members;

  //const Deleted({@required this.id});
  const Delete({@required this.member, this.members});

  @override
  List<Object> get props => [member, members];
  //List<Object> get props => [id];

  @override
  String toString() => 'Delete { member: $member, members: $members }';
//String toString() => 'Delete { id: $id }';
}

class Deleted extends ListEvent {
  //final String id;
  final int member;

  //const Deleted({@required this.id});
  const Deleted({@required this.member});

  @override
  List<Object> get props => [member];
  //List<Object> get props => [id];

  @override
  String toString() => 'Deleted { member: $member }';
//String toString() => 'Deleted { id: $id }';
}

class Updated extends ListEvent {
  final List<Member> members;

  const Updated(this.members);

  @override
  List<Object> get props => [members];
}
