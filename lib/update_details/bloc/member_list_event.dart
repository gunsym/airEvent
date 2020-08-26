import 'package:equatable/equatable.dart';

abstract class MemberListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MemberListFetched extends MemberListEvent {}
