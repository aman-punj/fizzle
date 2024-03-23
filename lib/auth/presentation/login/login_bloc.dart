import 'package:equatable/equatable.dart';
import 'package:fizzle/auth/util/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repo.dart';

class LoginScreenBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseAuthService firebaseAuthService;

  LoginScreenBloc({required this.firebaseAuthService})
      : super(LoginInitialState()) {
    on<DoLoginEvent>((event, emit) async {
      emit(LoginLoadingState());

      var result = await firebaseAuthService.login(event.email, event.password);
      switch (result.type) {
        case NetworkResultType.success:
          // print('Success: ${(result as Success<String>).data}');
          emit(LoginSuccessState(msg: (result as Success<String>).data));
          break;
        case NetworkResultType.error:
          // print(
          //     'Error: ${(result as Error<String>).code}, ${(result as Error<String>).message}');
          emit(LoginErrorState(msg: (result as Error<String>).message));
          break;
      }
    });
  }
}

abstract class LoginEvent extends Equatable {}

class DoLoginEvent extends LoginEvent {
  String email;
  String password;

  DoLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  String msg;

  LoginSuccessState({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoginErrorState extends LoginState {
  String msg;

  LoginErrorState({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoginCloseState extends LoginState {
  String message;

  LoginCloseState({required this.message});

  @override
  List<Object> get props => [message];
}
