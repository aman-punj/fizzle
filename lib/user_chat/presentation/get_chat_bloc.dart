// import 'package:fizzle/user_chat/modal/chat_modal.dart';
// import 'package:fizzle/user_chat/modal/chat_rapo.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// abstract class GetGetChatState {}
//
// class GetChatsLoadingState extends GetChatState {}
//
// class GetChatsLoadedState extends GetChatState {
//   final List<Message> chatData;
//
//   GetChatsLoadedState(this.chatData);
// }
//
// class GetChatsErrorState extends GetChatState {
//   final String errorMessage;
//
//   GetChatsErrorState(this.errorMessage);
// }
//
// class GetChatBloc extends Bloc<String, GetChatState> {
//   final ChatRepository chatRepo;
//
//   GetChatBloc(this.chatRepo) : super(GetChatsLoadingState()) {
//     on<String>((id, emit) async {
//       emit(GetChatsLoadingState());
//       const storage = FlutterSecureStorage();
//       String? selfPrivateKey = await storage.read(key: 'privateKey');
//       try {
//         final Stream<List<Message>> usersStream =
//             chatRepo.getChats(userId: id, selfPrivateKey: selfPrivateKey);
//         await for (List<Message> chatData in usersStream) {
//           emit(GetChatsLoadedState(chatData));
//         }
//       } catch (e) {
//         emit(GetChatsErrorState('Error fetching users: $e'));
//       }
//     });
//   }
// }

import 'package:equatable/equatable.dart';
import 'package:fizzle/auth/util/result.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../modal/chat_rapo.dart';

abstract class GetChatState {}

class GetChatsLoadingState extends GetChatState {}

class GetChatsSuccessState extends GetChatState {
  final List<Message> chatData;

  GetChatsSuccessState(this.chatData);
}

class GetChatsErrorState extends GetChatState {
  final String errorMessage;

  GetChatsErrorState(this.errorMessage);
}

class GetChatBloc extends Bloc<GetChatEvent, GetChatState> {
  final ChatRepository chatRepo;

  GetChatBloc(this.chatRepo) : super(GetChatsLoadingState()) {
    on<FetchGetChatsEvent>((event, emit) async {
      emit(GetChatsLoadingState());

      try {
        final Stream<List<Message>> usersStream =
        chatRepo.getChats(userId: event.id, /*selfPrivateKey: event.selfPrivateKey*/);
        await for (List<Message> chatData in usersStream) {
          emit(GetChatsSuccessState(chatData));
        }
      } catch (e) {
        emit(GetChatsErrorState('Error fetching users: $e'));
      }
    });
  }
}

abstract class GetChatEvent extends Equatable {}

class FetchGetChatsEvent extends GetChatEvent {
  final String id;
  // String? selfPrivateKey;

  FetchGetChatsEvent(/*this.selfPrivateKey,*/ {required this.id});

  @override
  List<Object?> get props => [];
}
