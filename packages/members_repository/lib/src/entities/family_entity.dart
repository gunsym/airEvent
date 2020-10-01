import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../models/member.dart';

class FamilyEntity extends Equatable {
  final String familyCode;
  final List<Member> members;

  const FamilyEntity(this.familyCode, this.members);

  Map<String, Object> toJson() {
    return {
      "familyCode": familyCode,
      "members": members,
    };
  }

  @override
  List<Object> get props => [familyCode, members];

  @override
  String toString() {
    return 'FamilyEntity { familyCode: $familyCode, members: $members }';
  }

  static FamilyEntity fromJson(Map<String, Object> json) {
    return FamilyEntity(
      json["familyCode"] as String,
      json["members"] as List<Member>,
    );
  }

  static FamilyEntity fromSnapshot(DocumentSnapshot snap) {
    /// using field name [familyCode]
    List family = snap.data['simplycaddie'];
    List<Member> myMembers = List<Member>();
    for(var member in family){
      //Member myMember = Member.fromJson(member);
      myMembers.add(Member.fromJson(member));
      //print(myMember);
    }
    //print(myMembers);
    //Member member = Member.fromJson(snap.data['Gunawan1'][0]);
    //print(member.toString());
    return FamilyEntity(
      snap.documentID,
      myMembers,
      //snap.data['members'],
    );
  }

  Map<String, Object> toDocument() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (members != null) {
      data[familyCode] = members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
