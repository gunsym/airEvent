import 'package:equatable/equatable.dart';
import 'package:air_event/update_details/member_list.dart';

abstract class MemberListState extends Equatable {
  const MemberListState();

  @override
  List<Object> get props => [];
}

class MemberListInitial extends MemberListState {}

class MemberListFailure extends MemberListState {}

class MemberListSuccess extends MemberListState {
  final List<MemberList> memberLists;
  final bool hasReachedMax;

  const MemberListSuccess({
    this.memberLists,
    this.hasReachedMax,
  });

  MemberListSuccess copyWith({
    List<MemberList> memberLists,
    bool hasReachedMax,
  }) {
    return MemberListSuccess(
      memberLists: memberLists ?? this.memberLists,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [memberLists, hasReachedMax];

  @override
  String toString() =>
      'MemberListLoaded { memberLists: ${memberLists.length}, hasReachedMax: $hasReachedMax }';
}
