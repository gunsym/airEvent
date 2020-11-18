import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:members_repository/src/models/event.dart';
import 'package:air_event/update_details/bloc/list_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class EventDetailsScreen extends StatelessWidget {
  final int event;
  final List<Event> events;

  EventDetailsScreen({Key key, @required this.event, @required this.events})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: events.elementAt(event) == null
          ? Container(
              child: Center(child: Text('Nothing to display')),
            )
          : Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(events.elementAt(event).name),
                    Text(events.elementAt(event).description),
                    BlocProvider(
                      create: (context) => EventDetailsBloc(),
                      child: Builder(
                        builder: (context) {
                          final formBloc = context.watch<EventDetailsBloc>();
                          return Column(
                            children: <Widget>[
                              CheckboxGroupFieldBlocBuilder<String>(
                                multiSelectFieldBloc: formBloc.name,
                                itemBuilder: (context, item) => item,
                                decoration: InputDecoration(
                                    labelText: 'Member',
                                    prefixIcon: SizedBox()),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    CheckboxListTile(
                      title: Text('Gunawan'),
                      value: false,
                      onChanged: (bool newValue) {},
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
  }
}

class EventDetailsBloc extends FormBloc<String, String> {
  final name = MultiSelectFieldBloc<String, dynamic>(items: [
    'GunawanG',
    'LucyG',
  ]);
  EventDetailsBloc() {
    addFieldBlocs(fieldBlocs: [name]);
  }
  @override
  void onSubmitting() {
    // TODO: implement onSubmitting
  }
}
