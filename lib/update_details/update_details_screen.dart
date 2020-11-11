import 'dart:async';
import 'dart:convert';
import 'package:air_event/update_details/bloc/list_bloc.dart';
import 'package:air_event/update_details/details_screen.dart';
import 'package:air_event/update_details/member_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:members_repository/members_repository.dart';

class UpdateDetailsBloc extends FormBloc<String, String> {
  final String email;
  final MembersRepository membersRepository;
  StreamSubscription _familySubscription;
  Family myFamily;
  final familyCode = TextFieldBloc(
    name: 'familyCode',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final members = ListFieldBloc<MemberFieldBloc>(name: 'members');

  UpdateDetailsBloc({
    @required this.email,
    @required this.membersRepository,
  }) : assert(email != null, membersRepository != null) {
    addFieldBlocs(
      fieldBlocs: [
        familyCode,
        members,
      ],
    );
  }

  void addMember() {
    members.addFieldBloc(MemberFieldBloc(
      name: 'member',
      firstName: TextFieldBloc(name: 'firstName'),
      lastName: TextFieldBloc(name: 'lastName'),
      specialNeeds: ListFieldBloc(name: 'specialNeeds'),
    ));
  }

  void removeMember(int index) {
    members.removeFieldBlocAt(index);
  }

  void addSpecialNeedsToMember(int memberIndex) {
    members.value[memberIndex].specialNeeds.addFieldBloc(TextFieldBloc());
    //members.value[memberIndex].specialNeeds.value[0].updateInitialValue('hi');
  }

  void removeSpecialNeedsFromMember(
      {@required int memberIndex, @required int specialNeedsIndex}) {
    members.value[memberIndex].specialNeeds
        .removeFieldBlocAt(specialNeedsIndex);
  }

  @override
  void onSubmitting() async {
    var existingMembers = myFamily.members.toList();
    var newMembers = members.value.map<Member>((memberField) {
      return Member(
        //id: id,
        email: email,
        firstName: memberField.firstName.value,
        lastName: memberField.lastName.value,
        familyCode: familyCode.value,
        specialNeeds: memberField.specialNeeds.value
            .map((specialNeedsField) => specialNeedsField.value)
            .toList(),
      );
    }).toList();
    var combinedMembers = [...?existingMembers, ...?newMembers];
    //print('combinedList ' + combinedMembers.toString());
    // Without serialization
    final familyV1 = Family(
      /// use registration type [family / individual]
      familyCode: 'family',
      members: combinedMembers,
    );

    //print('familyV1');
    //print(familyV1);
    try {
      await membersRepository.addFamily(familyV1);
    } catch (e) {
      print(e);
    }

    // With Serialization
//    final familyV2 = Family.fromJson(state.toJson());
//
//    print('familyV2');
//    print(familyV2);

    emitSuccess(
      canSubmitAgain: true,
      successResponse: JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ),
    );
  }
}

class MemberFieldBloc extends GroupFieldBloc {
  final TextFieldBloc firstName;
  final TextFieldBloc lastName;
  final ListFieldBloc<TextFieldBloc> specialNeeds;

  MemberFieldBloc({
    @required this.firstName,
    @required this.lastName,
    @required this.specialNeeds,
    String name,
  }) : super([firstName, lastName, specialNeeds], name: name);
}

class UpdateDetailsScreen extends StatelessWidget {
  final String email;
  final MembersRepository membersRepository;
  UpdateDetailsScreen(
      {Key key, @required this.email, @required this.membersRepository})
      : assert(email != null, membersRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateDetailsBloc(email: email, membersRepository: membersRepository),
      child: Builder(
        builder: (context) {
          //ignore: close_sinks
          final formBloc = context.watch<UpdateDetailsBloc>();
          final bottom = MediaQuery.of(context).viewInsets.bottom;

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text('Update Details')),
//              floatingActionButton: FloatingActionButton(
//                onPressed: formBloc.submit,
//                child: Icon(Icons.send),
//              ),
              body: FormBlocListener<UpdateDetailsBloc, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: SingleChildScrollView(
                          child: Text(state.successResponse)),
                      duration: Duration(milliseconds: 1500),
                    ));
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);

                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(state.failureResponse)));
                  },
                  child: BlocBuilder<UpdateDetailsBloc, FormBlocState>(
                    buildWhen: (previous, current) =>
                        previous.runtimeType != current.runtimeType ||
                        previous is FormBlocLoading &&
                            current is FormBlocLoading,
                    builder: (context, state) {
                      if (state is FormBlocLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is FormBlocLoadFailed) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.sentiment_dissatisfied, size: 70),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    state.failureResponse ??
                                        'An error has occurred please try again later',
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20),
                                RaisedButton(
                                  onPressed: formBloc.reload,
                                  child: Text('RETRY'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          reverse: true,
                          physics: ClampingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: bottom),
                            child: Column(
                              children: <Widget>[
                                TextFieldBlocBuilder(
                                  textFieldBloc: formBloc.familyCode,
                                  decoration: InputDecoration(
                                    labelText: 'Family Name',
                                    prefixIcon: Icon(Icons.sentiment_satisfied),
                                  ),
                                ),
                                BlocBuilder<ListBloc, ListState>(
                                  builder: (context, state) {
                                    if (state is Failure) {
                                      return Center(
                                        child:
                                            Text('Oops something went wrong!'),
                                      );
                                    }
                                    if (state is Loaded) {
                                      if (state.members.isEmpty) {
                                        return Center(
                                          child: Text('no content'),
                                        );
                                      }
                                      final members = state.members;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final member = members[index];
                                          return MemberTile(
                                            member: member,
                                            onDeletePressed: (member) {
                                              BlocProvider.of<ListBloc>(context)
                                                  .add(Delete(
                                                member: index,
                                                members: state.members,
                                              ));
                                            },
                                            onTap: () async {
                                              await Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_) {
                                                  return DetailsScreen(
                                                    member: index,
                                                    membersRepository:
                                                        membersRepository,
                                                  );
                                                }),
                                              );
                                            },
                                          );
//                                          return MemberTile(
//                                            member: member,
//                                            onTap: () async {
//                                              final removedTodo =
//                                                  await Navigator.of(context)
//                                                      .push(
//                                                MaterialPageRoute(builder: (_) {
//                                                  return DetailsScreen(
//                                                    index: index,
//                                                  );
////                                                  return DetailsScreen(
////                                                      id: todo.id);
//                                                }),
//                                              );
//                                              if (removedTodo != null) {}
//                                            },
//                                          );
                                        },
                                        itemCount: state.members.length,
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                                BlocBuilder<ListFieldBloc<MemberFieldBloc>,
                                    ListFieldBlocState<MemberFieldBloc>>(
                                  cubit: formBloc.members,
                                  builder: (context, state) {
                                    print(state.fieldBlocs);
                                    if (state.fieldBlocs.isNotEmpty) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: state.fieldBlocs.length,
                                        itemBuilder: (context, i) {
                                          return MemberCard(
                                            memberIndex: i,
                                            memberField: state.fieldBlocs[i],
                                            onRemoveMember: () =>
                                                formBloc.removeMember(i),
                                            onAddSpecialNeeds: () => formBloc
                                                .addSpecialNeedsToMember(i),
                                          );
                                        },
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.blue[100],
                                  onPressed: formBloc.addMember,
                                  child: Text('ADD MEMBER'),
                                ),
                                RaisedButton(
                                  color: Colors.red[200],
                                  onPressed: formBloc.submit,
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  )),
            ),
          );
        },
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final int memberIndex;
  final MemberFieldBloc memberField;

  final VoidCallback onRemoveMember;
  final VoidCallback onAddSpecialNeeds;

  const MemberCard({
    Key key,
    @required this.memberIndex,
    @required this.memberField,
    @required this.onRemoveMember,
    @required this.onAddSpecialNeeds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Member #${memberIndex + 1}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.firstName,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.lastName,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            BlocBuilder<ListFieldBloc<TextFieldBloc>,
                ListFieldBlocState<TextFieldBloc>>(
              cubit: memberField.specialNeeds,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.fieldBlocs.length,
                    itemBuilder: (context, i) {
                      //ignore: close_sinks
                      final specialNeedsFieldBloc = state.fieldBlocs[i];
                      return Card(
                        color: Colors.blue[50],
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFieldBlocBuilder(
                                textFieldBloc: specialNeedsFieldBloc,
                                decoration: InputDecoration(
                                  labelText: 'Special Needs #${i + 1}',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  memberField.specialNeeds.removeFieldBlocAt(i),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            FlatButton(
              color: Colors.white,
              onPressed: onAddSpecialNeeds,
              child: Text('ADD SPECIAL NEEDS'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

//class SuccessScreen extends StatelessWidget {
//  final MembersRepository membersRepository;
//  SuccessScreen({Key key, @required this.membersRepository})
//      : assert(membersRepository != null),
//        super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Icon(Icons.tag_faces, size: 100),
//            SizedBox(height: 10),
//            Text(
//              'Success',
//              style: TextStyle(fontSize: 54, color: Colors.black),
//              textAlign: TextAlign.center,
//            ),
//            SizedBox(height: 10),
//            RaisedButton.icon(
//              onPressed: () =>
//                  Navigator.of(context).pushReplacement(MaterialPageRoute(
//                      builder: (_) => UpdateDetailsScreen(
//                            membersRepository: membersRepository,
//                          ))),
//              icon: Icon(Icons.replay),
//              label: Text('AGAIN'),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
