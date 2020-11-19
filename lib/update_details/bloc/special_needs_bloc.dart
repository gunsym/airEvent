import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class SpecialNeedsFieldBloc extends GroupFieldBloc {
  final ListFieldBloc<TextFieldBloc> specialNeeds;

  SpecialNeedsFieldBloc({@required this.specialNeeds, String name})
      : super([specialNeeds], name: name);
}
