import 'package:air_event/event/event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:members_repository/members_repository.dart';

class EventPage extends StatelessWidget {
  final MembersRepository membersRepository;

  EventPage({@required this.membersRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(membersRepository: membersRepository),
      child: ,
    );
  }
}
