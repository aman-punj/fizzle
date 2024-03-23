import 'package:equatable/equatable.dart';
import 'package:fizzle/auth/util/result.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modal/chat_rapo.dart';
import 'chat_bloc.dart';

abstract class ChatState {}

class ChatsLoadingState extends ChatState {}

class ChatsSuccessState extends ChatState {
  /*final List<Message> msg;*/

  ChatsSuccessState(/*this.msg*/);
}

class ChatsErrorState extends ChatState {
  final String errorMessage;

  ChatsErrorState(this.errorMessage);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepo;

  ChatBloc(this.chatRepo) : super(ChatsLoadingState()) {
    on<SendMessageEvent>((event, emit) async {
      emit(ChatsLoadingState());

      final result = await chatRepo.sendMessage(event.message);
      switch (result.type) {
        case NetworkResultType.success:
          emit(ChatsSuccessState());
          break;
        case NetworkResultType.error:

          emit(ChatsErrorState('Error during sending message'));
          break;
      }
    });
  }
}

abstract class ChatEvent extends Equatable {}

class SendMessageEvent extends ChatEvent {
  final Message message;

  SendMessageEvent({required this.message});

  @override
  List<Object?> get props => [];
}
