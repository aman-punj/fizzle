import 'package:firebase_auth/firebase_auth.dart';
import 'package:fizzle/user_chat/presentation/chat_bloc.dart';
import 'package:fizzle/user_chat/presentation/get_chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String id;

  const ChatScreen({super.key, required this.userName, required this.id});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final scrollController = ScrollController();

  ChatBloc? chatBloc;
  GetChatBloc? getChatBloc;

  List<dynamic> _messages = [];

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // _loadDummyMessages();
    initView();
  }

  void initView() async {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    getChatBloc = BlocProvider.of<GetChatBloc>(context);

    getChatBloc!.add(widget.id);
  }

  // void _loadDummyMessages() {
  //   _messages = [
  //     Message(userId: '2', text: 'Hey how are you', time: DateTime.now()),
  //     Message(userId: '2', text: 'yeah i am fine', time: DateTime.now()),
  //     Message(userId: '1', text: 'this is awasome', time: DateTime.now()),
  //     Message(userId: '2', text: 'yeah really', time: DateTime.now()),
  //     Message(userId: '1', text: 'so what are you doing', time: DateTime.now()),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocListener<GetChatBloc, GetChatState>(
          listener: (context, state) async {
            if (state is GetChatsErrorState) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Something went wrong , try again later'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else if (state is GetChatsLoadedState) {
              setState(() {
                _messages = state.chatData;
                print('data should be');
                print(_messages);
              });
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          listener: (context, state) async {
            if (state is ChatsErrorState) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Something went wrong , try again later'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else if (state is ChatsSuccessState) {}
          },
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.userName),
        ),
        body: Column(
          children: [
            Expanded(
              child: _messages.isNotEmpty
                  ? ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Align(
                            alignment:
                                currentUser?.uid == _messages[index].userId
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                if (currentUser?.uid == _messages[index].userId)
                                  CircleAvatar(
                                    maxRadius: 10.0,
                                    backgroundColor: currentUser?.uid ==
                                            _messages[index].userId
                                        ? Colors.lightGreen
                                        : Colors.lightBlue,
                                    child: Text(
                                      widget.userName
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(fontSize: 10.sp),
                                    ),
                                  ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 6.0.h),
                                  decoration: BoxDecoration(
                                    color: currentUser?.uid ==
                                            _messages[index].userId
                                        ? Colors.lightGreen[300]
                                        : Colors.lightBlue[300],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        _messages[index].text,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        _dateFormatter(_messages[index].time),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Say Hii! 👋',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
            ),
            _messageField(),
          ],
        ),
      ),
    );
  }

  String _dateFormatter(DateTime dateTime) {
    final formatter = DateFormat.jm();
    final formattedTime = formatter.format(dateTime);
    return formattedTime;
  }

  Padding _messageField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 0.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLength: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          MaterialButton(
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  _sendMessage(_messageController.text);
                }
              },
              shape: const CircleBorder(),
              color: Colors.lightBlue[300],
              minWidth: 0,
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }

  void _sendMessage(String messageText) {
    final newMessage = Message(
      userId: widget.id,
      text: messageText,
      time: DateTime.now(),
    );

    chatBloc!.add(SendMessageEvent(message: newMessage));
    _messageController.clear();
  }
}
// Scroll to the bottom of the ListView
// scrollController.animateTo(
//   scrollController.position.maxScrollExtent,
//   duration: const Duration(milliseconds: 300),
//   curve: Curves.easeInOut,
// );
