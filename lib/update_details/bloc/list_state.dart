part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class Loading extends ListState {}

class Loaded extends ListState {
  //final List<Item> items;
  final List<Member> members;

  const Loaded({@required this.members});

  @override
  List<Object> get props => [members];

  @override
  String toString() => 'Loaded { items: ${members.length} }';
}

class Failure extends ListState {}
