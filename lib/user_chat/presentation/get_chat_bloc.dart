import 'package:fizzle/user_chat/modal/chat_modal.dart';
import 'package:fizzle/user_chat/modal/chat_rapo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GetChatState {}

class GetChatsLoadingState extends GetChatState {}

class GetChatsLoadedState extends GetChatState {
  final List<Message> chatData;

  GetChatsLoadedState(this.chatData);
}

class GetChatsErrorState extends GetChatState {
  final String errorMessage;

  GetChatsErrorState(this.errorMessage);
}

class GetChatBloc extends Bloc<String, GetChatState> {
  final ChatRepository chatRepo;

  GetChatBloc(this.chatRepo) : super(GetChatsLoadingState()) {
    on<String>((id, emit) async {
      emit(GetChatsLoadingState());

      try {
        final Stream<List<Message>> usersStream = chatRepo.getChats(userId: id);
        await for (List<Message> chatData in usersStream) {
          emit(GetChatsLoadedState(chatData));
        }
      } catch (e) {
        emit(GetChatsErrorState('Error fetching users: $e'));
      }
    });
  }
}
