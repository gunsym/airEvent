import '../entities/entities.dart';

class Member {
  String id;
  String firstName;
  String lastName;
  List<String> specialNeeds;
  bool isDeleting;

  Member(
      {this.firstName, this.lastName, this.id, this.specialNeeds, this.isDeleting = false});

  Member copyWith({String id,
    String firstName,
    String lastName,
    List<String> specialNeeds, bool isDeleting,
  }) {
    return Member(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      specialNeeds.hashCode ^
      isDeleting.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Member &&
              runtimeType == other.runtimeType &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              id == other.id &&
              specialNeeds == other.specialNeeds &&
              isDeleting == other.isDeleting;

  @override
  String toString() {
    return 'Member{firstName: $firstName, lastName: $lastName, id: $id, specialNeeds: $specialNeeds, isDeleting: $isDeleting}';
  }

  MemberEntity toEntity() {
        return MemberEntity(id, firstName, lastName, specialNeeds, isDeleting);
  }

  static Member fromEntity(MemberEntity entity) {
    return Member(
      firstName: entity.firstName,
      lastName: entity.lastName,
      id: entity.id,
      specialNeeds: entity.specialNeeds,
      isDeleting: entity.isDeleting,
    );
  }

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    specialNeeds = json['specialNeeds'].cast<String>();
    isDeleting = json['isDeleting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['specialNeeds'] = this.specialNeeds;
    data['isDeleting'] = this.isDeleting;
    return data;
  }
}
