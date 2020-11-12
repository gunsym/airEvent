import 'event.dart';
import '../entities/entities.dart';

class EventGroup {
  String groupCode;
  List<Event> events;

  EventGroup({this.groupCode, this.events});

  @override
  int get hashCode => groupCode.hashCode ^ events.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventGroup &&
              runtimeType == other.runtimeType &&
              groupCode == other.groupCode &&
              events == other.events;

  EventGroup.fromJson(Map<String, dynamic> json) {
    groupCode = json['groupCode'];
    if (json['events'] != null) {
      events = List<Event>();
      json['events'].forEach((v) {
        events.add(Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['groupCode'] = this.groupCode;
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() => '''EventGroup {
  groupCode: $groupCode,
  events: $events
}''';

  EventGroupEntity toEntity() {
    return EventGroupEntity(groupCode, events);
  }

  static EventGroup fromEntity(EventGroupEntity entity) {
    return EventGroup(
      groupCode: entity.groupCode,
      events: entity.events,
    );
  }
}