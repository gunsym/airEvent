import 'package:flutter/material.dart';
import 'package:air_event/update_details/bloc/special_needs_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class SpecialNeedsCard extends StatelessWidget {
  final int specialNeedsIndex;
  final SpecialNeedsFieldBloc specialNeedsField;

  const SpecialNeedsCard({
    Key key,
    @required this.specialNeedsIndex,
    @required this.specialNeedsField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            BlocBuilder<ListFieldBloc<TextFieldBloc>,
                ListFieldBlocState<TextFieldBloc>>(
              cubit: specialNeedsField.specialNeeds,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.fieldBlocs.length,
                      itemBuilder: (context, i) {
                        return Card(
                          color: Colors.blue[50],
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFieldBlocBuilder(
                                  textFieldBloc: state.fieldBlocs[i],
                                  decoration: InputDecoration(
                                    labelText: 'Special Needs #${i + 1}',
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete), onPressed: () {}),
                            ],
                          ),
                        );
                      });
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
