// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:members_repository/members_repository.dart';

abstract class MembersRepository {
  Future<void> addMember(Member member);

  Future<void> removeMember(Member member);

  Future<void> addFamily(Family family);

  Stream<Family> family(String id);

  /// Return all families
  /// useful later
  Stream<List<Family>> families();
}
