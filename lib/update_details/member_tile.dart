import 'package:flutter/material.dart';
import 'package:members_repository/members_repository.dart';

class MemberTile extends StatelessWidget {
  final Member member;
  final GestureTapCallback onTap;

  MemberTile({
    Key key,
    @required this.member,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(member.firstName),
      onTap: onTap,
    );
  }
}
