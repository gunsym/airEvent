import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MemberEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final List<String> specialNeeds;

  const MemberEntity(this.id, this.firstName, this.lastName, this.specialNeeds);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "specialNeeds": specialNeeds,
    };
  }

  @override
  List<Object> get props => [id, firstName, lastName, specialNeeds];

  @override
  String toString() {
    return 'MemberEntity { firstName: $firstName, lastName: $lastName, id: $id, specialNeeds: $specialNeeds }';
  }

  static MemberEntity fromJson(Map<String, Object> json) {
    return MemberEntity(
      json["id"] as String,
      json["firstName"] as String,
      json["lastName"] as String,
      json["specialNeeds"] as List<String>,
    );
  }

  static MemberEntity fromSnapshot(DocumentSnapshot snap) {
    return MemberEntity(
      snap.data['firstName'],
      snap.documentID,
      snap.data['lastName'],
      snap.data['specialNeeds'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "specialNeeds": specialNeeds,
    };
  }
}
