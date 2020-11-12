import '../entities/entities.dart';
import 'package:air_event/widgets/uuid.dart';

class Member {
  String id;
  String email;
  String firstName;
  String lastName;
  List<String> specialNeeds;
  String familyCode;
  bool isDeleting;

  Member(
      {this.firstName,
        this.lastName,
        String id,
        this.email,
        this.familyCode,
        this.specialNeeds,
        this.isDeleting = false,
      }) : this.id = id ?? Uuid().generateV4();

  Member copyWith({String id,
    String firstName,
    String lastName,
    String email,
    String familyCode,
    List<String> specialNeeds, bool isDeleting,
  }) {
    return Member(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      familyCode: familyCode ?? this.familyCode,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      familyCode.hashCode ^
      specialNeeds.hashCode ^
      isDeleting.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Member &&
              runtimeType == other.runtimeType &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              email == other.email &&
              familyCode == other.familyCode &&
              id == other.id &&
              specialNeeds == other.specialNeeds &&
              isDeleting == other.isDeleting;

  @override
  String toString() {
    return 'Member{firstName: $firstName, lastName: $lastName, email: $email, familyCode: $familyCode, id: $id, specialNeeds: $specialNeeds, isDeleting: $isDeleting}';
  }

  MemberEntity toEntity() {
        return MemberEntity(id, firstName, lastName, email, familyCode, specialNeeds, isDeleting);
  }

  static Member fromEntity(MemberEntity entity) {
    return Member(
      firstName: entity.firstName,
      lastName: entity.lastName,
      id: entity.id,
      email: entity.email,
      familyCode: entity.familyCode,
      specialNeeds: entity.specialNeeds,
      isDeleting: entity.isDeleting,
    );
  }

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    familyCode = json['familyCode'];
    specialNeeds = json['specialNeeds'].cast<String>();
    isDeleting = json['isDeleting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['familyCode'] = this.familyCode;
    data['specialNeeds'] = this.specialNeeds;
    data['isDeleting'] = this.isDeleting;
    return data;
  }
}
