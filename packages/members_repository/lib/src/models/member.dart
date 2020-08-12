import '../entities/entities.dart';

class Member {
  String id;
  String firstName;
  String lastName;
  List<String> specialNeeds;

  Member({this.firstName, this.lastName, this.id, this.specialNeeds});

  Member copyWith(
      {String id,
      String firstName,
      String lastName,
      List<String> specialNeeds}) {
    return Member(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      specialNeeds: specialNeeds ?? this.specialNeeds,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      specialNeeds.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Member &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          id == other.id &&
          specialNeeds == other.specialNeeds;

  @override
  String toString() {
    return 'Member{firstName: $firstName, lastName: $lastName, id: $id, specialNeeds: $specialNeeds}';
  }

  MemberEntity toEntity() {
    return MemberEntity(id, firstName, lastName, specialNeeds);
  }

  static Member fromEntity(MemberEntity entity) {
    return Member(
      firstName: entity.firstName,
      lastName: entity.lastName,
      id: entity.id,
      specialNeeds: entity.specialNeeds,
    );
  }

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    specialNeeds = json['specialNeeds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['specialNeeds'] = this.specialNeeds;
    return data;
  }
}
