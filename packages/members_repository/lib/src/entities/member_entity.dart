import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MemberEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final List<String> specialNeeds;
  final bool isDeleting;

  const MemberEntity(this.id, this.firstName, this.lastName, this.email, this.specialNeeds, this.isDeleting);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "specialNeeds": specialNeeds,
      "isDeleting": isDeleting,
    };
  }

  @override
  List<Object> get props => [id, firstName, lastName, email, specialNeeds, isDeleting];

  @override
  String toString() {
    return 'MemberEntity { firstName: $firstName, lastName: $lastName, email: $email, id: $id, specialNeeds: $specialNeeds, isDeleting: $isDeleting }';
  }

  static MemberEntity fromJson(Map<String, Object> json) {
    return MemberEntity(
      json["id"] as String,
      json["firstName"] as String,
      json["lastName"] as String,
      json["email"] as String,
      json["specialNeeds"] as List<String>,
      json["isDeleting"] as bool,
    );
  }

  static MemberEntity fromSnapshot(DocumentSnapshot snap) {
    return MemberEntity(
      snap.data['firstName'],
      snap.documentID,
      snap.data['lastName'],
      snap.data['email'],
      snap.data['specialNeeds'],
      snap.data['isDeleting'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "specialNeeds": specialNeeds,
      "isDeleting": isDeleting,
    };
  }
}
