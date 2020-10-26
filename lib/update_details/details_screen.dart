import 'package:air_event/update_details/bloc/list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:members_repository/members_repository.dart';

class DetailsScreen extends StatelessWidget {
  final int member;
  final MembersRepository membersRepository;

  DetailsScreen(
      {Key key, @required this.member, @required this.membersRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        final members = (state as Loaded).members;
        //final member = members.elementAt(index);
        return Scaffold(
          appBar: AppBar(
            title: Text('Member Details'),
          ),
          body: members.elementAt(member) == null
              ? Container() //: LoginForm(),
              : AllFieldsForm(
                  member: member,
                  members: members,
                  membersRepository: membersRepository,
                ),
        );
      },
    );
  }
}

class AllFieldsFormBloc extends FormBloc<String, String> {
  final firstName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final lastName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(
      validators: [FieldBlocValidators.required, FieldBlocValidators.email]);
  final specialNeeds = ListFieldBloc();
  final int member;
  final List<Member> members;
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
      emitLoaded();
    } catch (e) {
      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() async {
    var memberList = members.toList();
    var editedMember = Member(
      email: email.value,
      firstName: firstName.value,
      lastName: lastName.value,
      specialNeeds: [],
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

class AllFieldsForm extends StatelessWidget {
  final int member;
  final List<Member> members;
  final MembersRepository membersRepository;

  AllFieldsForm(
      {@required this.member,
      @required this.members,
      @required this.membersRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllFieldsFormBloc(
          member: member,
          members: members,
          membersRepository: membersRepository),
      child: Builder(
        builder: (context) {
          //final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);
          final formBloc = context.bloc<AllFieldsFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              body: FormBlocListener<AllFieldsFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

//                  Navigator.of(context).pushReplacement(MaterialPageRoute(
//                      builder: (_) => SuccessScreen(member: member)));
                  Navigator.pop(context);
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse)));
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.firstName,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.lastName,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        BlocBuilder<ListFieldBloc<TextFieldBloc>,
                            ListFieldBlocState<TextFieldBloc>>(
                          cubit: formBloc.specialNeeds,
                          builder: (context, state) {
                            return null;
                          },
                        ),
                        RaisedButton(
                          color: Colors.red[200],
                          onPressed: formBloc.submit,
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
//  final Member member;
//
//  SuccessScreen({Key key, @required this.member}) : super(key: key);
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
//                      builder: (_) => AllFieldsForm(
//                            member: member,
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
