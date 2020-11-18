import 'package:flutter/material.dart';
import 'package:members_repository/src/models/event.dart';

class EventDetailsScreen extends StatelessWidget {
  final int event;
  final List<Event> events;

  EventDetailsScreen({Key key, @required this.event, @required this.events})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Details'),
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
