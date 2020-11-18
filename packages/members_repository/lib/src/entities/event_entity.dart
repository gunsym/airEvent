import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String description;

  const EventEntity(this.id, this.code, this.name, this.description);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
      "description": description,
    };
  }

  @override
  List<Object> get props => [id, code, name, description];

  @override
  String toString() {
    return 'EventEntity { code: $code, name: $name, id: $id, description: $description';
  }

  static EventEntity fromJson(Map<String, Object> json) {
    return EventEntity(
      json["code"] as String,
      json["name"] as String,
      json["id"] as String,
      json["description"] as String,
    );
  }

  static EventEntity fromSnapshot(DocumentSnapshot snap) {
    return EventEntity(
      snap.data['code'],
      snap.data['name'],
      snap.documentID,
      snap.data['description'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "code": code,
      "name": name,
      "description": description,
    };
  }
}