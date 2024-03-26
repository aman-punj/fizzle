// import 'package:equatable/equatable.dart';
// import 'package:fizzle/user_chat/modal/chat_rapo.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../modal/chat_modal.dart';
//
// class DeleteMSgBloc extends Bloc<DeleteMSgEvent, DeleteMSgState> {
//   final ChatRepository chatRepo;
//
//   DeleteMSgBloc(this.chatRepo) : super(DeleteMSgLoadingState()) {
//
//     on<FetchDeleteMsgEvent>((event, emit) async{
//       emit(DeleteMSgLoadingState());
//
//     });
//   }
// }
//
// abstract class DeleteMSgEvent extends Equatable {}
//
// class FetchDeleteMsgEvent extends DeleteMSgEvent {
//   final Message message;
//
//   FetchDeleteMsgEvent({required this.message});
//
//   @override
//   List<Object?> get props => [];
// }
//
// abstract class DeleteMSgState {}
//
// class DeleteMSgInitialState extends DeleteMSgState {}
//
// class DeleteMSgLoadingState extends DeleteMSgState {}
//
// class DeleteMSgSuccessState extends DeleteMSgState {}
//
// class DeleteMSgErrorState extends DeleteMSgState {}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fizzle/auth/util/result.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';

import '../modal/chat_rapo.dart';

abstract class DeleteMsgState {}

class DeleteMsgLoadingState extends DeleteMsgState {}

class DeleteMsgSuccessState extends DeleteMsgState {
  final Message messages;

  DeleteMsgSuccessState({required this.messages});
}

class DeleteMsgErrorState extends DeleteMsgState {
  final String errorMessage;

  DeleteMsgErrorState(this.errorMessage);
}

class DeleteMsgEvent extends Equatable {
  final Message userMsg;
  final bool isDeleteAll;

  const  DeleteMsgEvent(this.userMsg , this.isDeleteAll);

  @override
  List<Object?> get props => [userMsg];
}

class DeleteMsgBloc extends Bloc<DeleteMsgEvent, DeleteMsgState> {
  final ChatRepository chatRepo;

  DeleteMsgBloc(this.chatRepo) : super(DeleteMsgLoadingState()) {
    on<DeleteMsgEvent>((event, emit) async {
      emit(DeleteMsgLoadingState());

      final result = await chatRepo.deleteMessage(event.userMsg , deleteForAll:  event.isDeleteAll);
      switch (result.type) {
        case NetworkResultType.success:
          emit(DeleteMsgSuccessState(messages: event.userMsg));
          break;
        case NetworkResultType.error:
          emit(DeleteMsgErrorState('Error during fetching messages'));
          break;
      }
    });
  }
}
