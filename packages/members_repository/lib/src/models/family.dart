import 'member.dart';
import '../entities/entities.dart';

class Family {
  String familyCode;
  List<Member> members;

  Family({this.familyCode, this.members});

  @override
  int get hashCode => familyCode.hashCode ^ members.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Family &&
          runtimeType == other.runtimeType &&
          familyCode == other.familyCode &&
          members == other.members;

  Family.fromJson(Map<String, dynamic> json) {
    familyCode = json['familyCode'];
    if (json['members'] != null) {
      members = List<Member>();
      json['members'].forEach((v) {
        members.add(Member.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['familyCode'] = this.familyCode;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() => '''Family {
  familyCode: $familyCode,
  members: $members
}''';

  FamilyEntity toEntity() {
    return FamilyEntity(familyCode, members);
  }

  static Family fromEntity(FamilyEntity entity) {
    return Family(
      familyCode: entity.familyCode,
      members: entity.members,
    );
  }
}
