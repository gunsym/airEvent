import 'package:equatable/equatable.dart';
import 'package:air_event/update_details/models/models.dart';

abstract class MemberListState extends Equatable {
  const MemberListState();

  @override
  List<Object> get props => [];
}

class MemberListInitial extends MemberListState {}

class MemberListFailure extends MemberListState {}

class MemberListSuccess extends MemberListState {
  final List<MemberList> memberList;
  final bool hasReachedMax;

  const MemberListSuccess({
    this.memberList,
    this.hasReachedMax,
  });

  MemberListSuccess copyWith({
    List<MemberList> posts,
    bool hasReachedMax,
  }) {
    return MemberListSuccess(
      memberList: posts ?? this.memberList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [memberList, hasReachedMax];

  @override
  String toString() =>
      'MemberListLoaded { memberLists: ${memberList.length}, hasReachedMax: $hasReachedMax }';
}
