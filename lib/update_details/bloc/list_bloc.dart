import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:members_repository/members_repository.dart';
import 'package:meta/meta.dart';
import 'package:air_event/update_details/repository.dart';
import 'package:air_event/update_details/models/models.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  //final Repository repository;
  final MembersRepository membersRepository;
  StreamSubscription _familySubscription;
  List myList;

  ListBloc({@required this.membersRepository}) : super(Loading());

  @override
  Stream<ListState> mapEventToState(
    ListEvent event,
  ) async* {
    if (event is Fetch) {
      yield* _mapLoadListToState();
    }
    if (event is Updated) {
      yield* _mapListUpdateToState(event);
    }
    if (event is Delete) {
      yield* _mapDeleteListToState(event);
      // final listState = state;
      // if (listState is Loaded) {
      //   final List<Item> updatedItems =
      //       List<Item>.from(listState.items).map((Item item) {
      //     return item.id == event.id ? item.copyWith(isDeleting: true) : item;
      //   }).toList();
      //   yield Loaded(items: updatedItems);
      //   repository.deleteItem(event.id).listen((id) {
      //     add(Deleted(id: id));
      //   });
      // }
    }
    if (event is Deleted) {
      // final listState = state;
      // if (listState is Loaded) {
      //   final List<Item> updatedItems = List<Item>.from(listState.items)
      //     ..removeWhere((item) => item.id == event.id);
      //   yield Loaded(items: updatedItems);
      // }
    }
  }

  Stream<ListState> _mapLoadListToState() async* {
    try {
      //final items = await repository.fetchItems();
      _familySubscription?.cancel();
      _familySubscription =
          membersRepository.family('simplycaddie.com@gmail.com').listen(
                (family) => add(Updated(family.members)),
              );
      //{
      //myList = family.members.map((e) => e.toJson()).toList();
      //print(myList);
      //});
      //print(myList);
      //yield Loaded(members: myList);
    } catch (e) {
      print(e);
      yield Failure();
    }
  }

  Stream<ListState> _mapListUpdateToState(Updated event) async* {
    yield Loaded(members: event.members);
  }

  Stream<ListState> _mapDeleteListToState(Delete event) async* {
    membersRepository.removeMember(event.member);
  }

  @override
  Future<void> close() {
    _familySubscription?.cancel();
    return super.close();
  }
}
