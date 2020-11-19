import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:members_repository/members_repository.dart';

class AllFieldsFormBloc extends FormBloc<String, String> {
  final firstName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final lastName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(
      validators: [FieldBlocValidators.required, FieldBlocValidators.email]);
  //final specialNeeds1 = TextFieldBloc();
//  final specialNeeds =
//      ListFieldBloc<SpecialNeedsFieldBloc>(name: 'specialNeeds');
  //List list = [];
  //for(var i=0;i<10;i++){

  //}
  final int member;
  final List<Member> members;
  final specialNeeds = ListFieldBloc<TextFieldBloc>(
      name: 'specialNeeds',
      // hardcoded value, need to fix
      fieldBlocs: List.generate(30, (index) => TextFieldBloc()));
  final MembersRepository membersRepository;

  AllFieldsFormBloc(
      {@required this.member,
      @required this.members,
      @required this.membersRepository})
      : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [
      firstName,
      lastName,
      email,
      specialNeeds,
    ]);
  }

  @override
  void onLoading() async {
    try {
      var selectedMember = members[member];
      firstName.updateInitialValue(selectedMember.firstName);
      lastName.updateInitialValue(selectedMember.lastName);
      email.updateInitialValue(selectedMember.email);
      //specialNeeds.addFieldBloc(TextFieldBloc());
      var last = 0;
      for (var i = 0; i < selectedMember.specialNeeds.length; i++) {
        specialNeeds.value[i]
            .updateInitialValue(selectedMember.specialNeeds[i]);
        last++;
      }

      /// todo: need to fix hardcoded value
      for (var i = 30 - 1; i >= last; i--) {
        specialNeeds.removeFieldBlocAt(i);
      }
      emitLoaded();
    } catch (e) {
      emitLoadFailed();
    }
  }

  void addSpecialNeeds() {
    specialNeeds.addFieldBloc(TextFieldBloc());
  }

  @override
  void onSubmitting() async {
    var memberList = members.toList();
    var editedMember = Member(
      email: email.value,
      firstName: firstName.value,
      lastName: lastName.value,
      specialNeeds: specialNeeds.value
          .map((specialNeedsField) => specialNeedsField.value)
          .toList(),
      familyCode: email.value,
    );
    memberList[member] = editedMember;

    final familyV1 = Family(
      /// use registration type [family / individual]
      familyCode: 'family',
      members: memberList,
    );
    print(familyV1.toString());
    try {
      await membersRepository.addFamily(familyV1);
      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      emitFailure();
    }
  }
}
