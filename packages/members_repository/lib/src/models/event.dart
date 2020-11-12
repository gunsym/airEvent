import '../entities/entities.dart';
import 'package:air_event/widgets/uuid.dart';

class Event {
  String id;
  String code;
  String name;

  Event(
      {String id,
        this.name,
        this.code
      }) : this.id = id ?? Uuid().generateV4();

  Event copyWith({String id,
    String code,
    String name,
  }) {
      return Event(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
      );
  }

  @override
  int get hashCode =>
  id.hashCode ^
  name.hashCode ^
  code.hashCode;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
        other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          code == other.code;

  @override
  String toString() {
    return 'Event{code: $code, name: $name, id: $id}';
  }

  EventEntity toEntity(){
    return EventEntity(id, code, name);
  }

  static Event fromEntity(EventEntity entity) {
    return Event(
      code: entity.code,
      name: entity.name,
      id: entity.id,
    );
  }

  Event.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
