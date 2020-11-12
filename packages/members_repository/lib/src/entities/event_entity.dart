import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String code;
  final String name;

  const EventEntity(this.id, this.code, this.name);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "code": code,
      "name": name,
    };
  }

  @override
  List<Object> get props => [id, code, name];

  @override
  String toString() {
    return 'EventEntity { code: $code, name: $name, id: $id';
  }

  static EventEntity fromJson(Map<String, Object> json) {
    return EventEntity(
      json["code"] as String,
      json["name"] as String,
      json["id"] as String,
    );
  }

  static EventEntity fromSnapshot(DocumentSnapshot snap) {
    return EventEntity(
      snap.data['code'],
      snap.data['name'],
      snap.documentID,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "code": code,
      "name": name,
    };
  }
}