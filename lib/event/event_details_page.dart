import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:members_repository/members_repository.dart';
import 'package:members_repository/src/models/event.dart';
import 'package:air_event/update_details/bloc/list_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:air_event/event/bloc/event_details_bloc.dart';

class EventDetailsScreen extends StatelessWidget {
  final int event;
  final List<Event> events;
  final MembersRepository membersRepository;

  EventDetailsScreen(
      {Key key,
      @required this.event,
      @required this.events,
      @required this.membersRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        final members = (state as Loaded).members;
        //print(members);
        return Scaffold(
          appBar: AppBar(
            title: Text('Event Details'),
          ),
          body: events.elementAt(event) == null
              ? Container(
                  child: Center(child: Text('Nothing to display')),
                )
              : SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(events.elementAt(event).name),
                        Text(events.elementAt(event).description),
                        BlocProvider(
                          create: (context) =>
                              EventDetailsBloc(members: members),
                          child: Builder(
                            builder: (context) {
                              final formBloc =
                                  context.watch<EventDetailsBloc>();
                              return BlocBuilder<EventDetailsBloc,
                                  FormBlocState>(builder: (context, state) {
                                return Column(
                                  children: <Widget>[
                                    CheckboxGroupFieldBlocBuilder<String>(
                                      multiSelectFieldBloc: formBloc.name,
                                      itemBuilder: (context, item) => item,
                                      decoration: InputDecoration(
                                          labelText: 'Select Registrants',
                                          prefixIcon: SizedBox()),
                                    ),
                                  ],
                                );
                              });
                            },
                          ),
                        ),
                        RaisedButton(
                          color: Colors.red[200],
                          onPressed: () {},
                          child: Text('REGISTER'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

//class EventDetailsForm extends StatelessWidget{
//
//}
