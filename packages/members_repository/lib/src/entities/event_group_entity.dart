import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../models/event.dart';

class EventGroupEntity extends Equatable {
  final String groupCode;
  final List<Event> events;

  const EventGroupEntity(this.groupCode, this.events);

  Map<String, Object> toJson() {
    return {
      "groupCode": groupCode,
      "event": events,
    };
  }

  @override
  List<Object> get props => [groupCode, events];

  @override
  String toString() {
    return 'EventGroupEntity { groupCode: $groupCode, events: $events }';
  }

  static EventGroupEntity fromJson(Map<String, Object> json) {
    return EventGroupEntity(
      json["groupCode"] as String,
      json["events"] as List<Event>,
    );
  }

  static EventGroupEntity fromSnapshot(DocumentSnapshot snap) {
    /// using registration type [family / individual]
    List eventGroup = snap.data['conferences'];
    List<Event> myEvents = List<Event>();
    for(var event in eventGroup){
      //Member myMember = Member.fromJson(member);
      myEvents.add(Event.fromJson(event));
      //print(myMember);
    }
    //print(myMembers);
    //Member member = Member.fromJson(snap.data['Gunawan1'][0]);
    //print(member.toString());
    return EventGroupEntity(
      snap.documentID,
      myEvents,
      //snap.data['members'],
    );
  }

  Map<String, Object> toDocument() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (events != null) {
      data[groupCode] = events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}