import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:members_repository/members_repository.dart';

class EventDetailsBloc extends FormBloc<String, String> {
  final List<Member> members;
  final name = MultiSelectFieldBloc<String, dynamic>();
  EventDetailsBloc({@required this.members}) : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [name]);
  }
  @override
  void onSubmitting() {
    // TODO: implement onSubmitting
  }
  @override
  void onLoading() async {
    List<String> myList = List();
    try {
      members.forEach((element) {
        myList.add(element.firstName);
      });
      //print(myList);
      await name.updateItems(myList);
      emitLoaded();
    } catch (e) {
      print(e);
      emitLoadFailed();
    }
  }
}
