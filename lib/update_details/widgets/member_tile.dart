import 'package:flutter/material.dart';
import 'package:members_repository/members_repository.dart';

class MemberTile extends StatelessWidget {
  final Member member;
  final Function(String) onDeletePressed;
  final GestureTapCallback onTap;

  const MemberTile({
    Key key,
    @required this.member,
    @required this.onDeletePressed,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(member.firstName),
      onTap: onTap,
      trailing: member.isDeleting
          ? CircularProgressIndicator()
          : IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDeletePressed(member.id),
            ),
    );
  }
}
