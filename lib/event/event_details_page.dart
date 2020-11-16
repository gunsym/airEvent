import 'package:flutter/material.dart';
import 'package:members_repository/members_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:air_event/event/event_bloc.dart';

class EventDetailsScreen extends StatelessWidget {
  final int event;
  final MembersRepository membersRepository;

  EventDetailsScreen(
      {Key key, @required this.event, @required this.membersRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        print(state);
        final events = (state as Loaded).events;
        //final member = members.elementAt(index);
        return Scaffold(
          appBar: AppBar(
            title: Text('Member Details'),
          ),
          body: events.elementAt(event) == null ? Container() : Container(),
        );
      },
    );
  }
}
