
import 'package:equatable/equatable.dart';
import 'package:fizzle/auth/util/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repo.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  FirebaseAuthService firebaseAuthService;

  SignUpBloc({required this.firebaseAuthService})
      : super(SignUpInitialState()) {
    on<DoSignUpEvent>((event, emit) async {
      emit(SignUpLoadingState());
      var result = await firebaseAuthService.signUp(event.email, event.password ,  event.userName);
      switch (result.type) {
        case NetworkResultType.success:
        // print('Success: ${(result as Success<String>).data}');
          emit(SignUpSuccessState(msg: (result as Success<String>).data));
          break;
        case NetworkResultType.error:
        // print(
        //     'Error: ${(result as Error<String>).code}, ${(result as Error<String>).message}');
          emit(SignUpErrorState(msg: (result as Error<String>).message));
          break;
      }
    });
  }
}

abstract class SignUpEvent extends Equatable {}

class DoSignUpEvent extends SignUpEvent {
  final String email;
  final String password;
  final String userName;

  DoSignUpEvent({required this.email, required this.password  , required this.userName});

  @override
  List<Object?> get props => [email, password];
}

abstract class SignUpState extends Equatable {}

class SignUpInitialState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpLoadingState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpSuccessState extends SignUpState {
  final String msg;

  SignUpSuccessState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class SignUpErrorState extends SignUpState {
  final String msg;

  SignUpErrorState({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class SignUpCloseState extends SignUpState {
  final String message;

  SignUpCloseState({required this.message});

  @override
  List<Object?> get props => [message];
}
