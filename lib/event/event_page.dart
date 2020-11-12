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
      create: (context) =>
          EventBloc(membersRepository: membersRepository)..add(Fetch()),
      child: Builder(
        builder: (context) {
          final bottom = MediaQuery.of(context).viewInsets.bottom;

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text('Events')),
              body: SingleChildScrollView(
                reverse: true,
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Column(
                    children: <Widget>[
                      BlocBuilder<EventBloc, EventState>(
                        builder: (context, state) {
                          print(state);
                          if (state is Failure) {
                            return Center(
                              child: Text('Oops something went wrong!'),
                            );
                          }
                          if (state is Loaded) {
                            if (state.events.isEmpty) {
                              return Center(
                                child: Text('no content'),
                              );
                            }
                            final events = state.events;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final event = events[index];
                                return Text(event.name);
                              },
                              itemCount: state.events.length,
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
