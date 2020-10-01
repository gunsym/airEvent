// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:members_repository/members_repository.dart';
import 'package:members_repository/src/entities/entities.dart';

class FirebaseMembersRepository implements MembersRepository {
  final memberCollection = Firestore.instance.collection('members');

  @override
  Future<void> addMember(Member member) {
    return memberCollection
        .document(member.id)
        .setData(member.toEntity().toDocument());
  }

  @override
  Future<void> removeMember(int member, List<Member> members) async {
    //var myMembers = List.from(members);
    members.removeAt(member);
    final familyV1 = Family(
      /// use registration type [family / individual]
      familyCode: 'family',
      members: members,
    );
    print('DELETE INDEX : '+ member.toString());
    print('LIST OF MEMBERS : '+ members.toString());
    //TODO: duplicate family, remove member and set data
    //return memberCollection.document(members[0].email).updateData({'simplycaddie': []});
    return memberCollection
        .document(members[0].email)
        .setData(familyV1.toEntity().toDocument());
  }

  Future<void> addFamily(Family family) {
    //TODO: add to current list (check if not empty)
    return memberCollection
        .document(family.members[0].email)
        .setData(family.toEntity().toDocument());
  }

  Stream<Family> family(String id) {
    return memberCollection.document(id).snapshots().map((snapshot) => Family.fromEntity(FamilyEntity.fromSnapshot(snapshot)));
  }

  Stream<List<Family>> families() {
    return memberCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Family.fromEntity(FamilyEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
