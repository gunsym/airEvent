import '../entities/entities.dart';
import 'dart:math';

class Member {
  String id;
  String email;
  String firstName;
  String lastName;
  List<String> specialNeeds;
  bool isDeleting;

  Member(
      {this.firstName,
        this.lastName,
        String id,
        this.email,
        this.specialNeeds,
        this.isDeleting = false,
      }) : this.id = id ?? Uuid().generateV4();

  Member copyWith({String id,
    String firstName,
    String lastName,
    String email,
    List<String> specialNeeds, bool isDeleting,
  }) {
    return Member(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
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
              id == other.id &&
              specialNeeds == other.specialNeeds &&
              isDeleting == other.isDeleting;

  @override
  String toString() {
    return 'Member{firstName: $firstName, lastName: $lastName, email: $email, id: $id, specialNeeds: $specialNeeds, isDeleting: $isDeleting}';
  }

  MemberEntity toEntity() {
        return MemberEntity(id, firstName, lastName, email, specialNeeds, isDeleting);
  }

  static Member fromEntity(MemberEntity entity) {
    return Member(
      firstName: entity.firstName,
      lastName: entity.lastName,
      id: entity.id,
      email: entity.email,
      specialNeeds: entity.specialNeeds,
      isDeleting: entity.isDeleting,
    );
  }

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    specialNeeds = json['specialNeeds'].cast<String>();
    isDeleting = json['isDeleting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['specialNeeds'] = this.specialNeeds;
    data['isDeleting'] = this.isDeleting;
    return data;
  }
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

/// A UUID generator, useful for generating unique IDs for your Todos.
/// Shamelessly extracted from the Flutter source code.
///
/// This will generate unique IDs in the format:
///
///     f47ac10b-58cc-4372-a567-0e02b2c3d479
///
/// ### Example
///
///     final String id = Uuid().generateV4();
class Uuid {
  final Random _random = Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
