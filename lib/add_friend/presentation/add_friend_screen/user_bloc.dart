import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../../core/models/user_models.dart';
import '../../data/user_repo.dart';

enum UserEvent { fetchUsers }

abstract class UserState {}

class UsersLoadingState extends UserState {}

class UsersLoadedState extends UserState {
  final List<User> users;

  UsersLoadedState(this.users);
}

class UsersErrorState extends UserState {
  final String errorMessage;

  UsersErrorState(this.errorMessage);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UsersLoadingState()) {
    on<UserEvent>((event, emit) async {
      if (event == UserEvent.fetchUsers) {
        emit(UsersLoadingState());

        try {
          final Stream<List<User>> usersStream = userRepository.getUsersStream();
          await for (List<User> users in usersStream) {
            emit(UsersLoadedState(users));
          }
        } catch (e) {
          emit(UsersErrorState('Error fetching users: $e'));
        }
      }
    });
  }
}