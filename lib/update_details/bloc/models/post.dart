import 'package:equatable/equatable.dart';

class MemberList extends Equatable {
  final int id;
  final String title;
  final String body;

  const MemberList({this.id, this.title, this.body});

  @override
  List<Object> get props => [id, title, body];

  @override
  String toString() => 'Post { id: $id }';
}
