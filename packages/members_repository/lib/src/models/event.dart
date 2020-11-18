import '../entities/entities.dart';
import 'package:air_event/widgets/uuid.dart';

class Event {
  String id;
  String code;
  String name;
  String description;

  Event(
      {String id,
        this.name,
        this.code,
        this.description
      }) : this.id = id ?? Uuid().generateV4();

  Event copyWith({String id,
    String code,
    String name,
    String description,
  }) {
      return Event(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        description: code ?? this.description,
      );
  }

  @override
  int get hashCode =>
  id.hashCode ^
  name.hashCode ^
  code.hashCode ^
  description.hashCode;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
        other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          code == other.code &&
          description == other.description;

  @override
  String toString() {
    return 'Event{code: $code, name: $name, id: $id, description: $description}';
  }

  EventEntity toEntity(){
    return EventEntity(id, code, name, description);
  }

  static Event fromEntity(EventEntity entity) {
    return Event(
      code: entity.code,
      name: entity.name,
      id: entity.id,
      description: entity.description,
    );
  }

  Event.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['id'] = this.id;
    data['description'] = this.description;
    return data;
  }
}
