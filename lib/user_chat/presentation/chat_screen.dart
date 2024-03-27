import 'package:firebase_auth/firebase_auth.dart';
import 'package:fizzle/core/presentation/components/custom_widgets/loader_widget.dart';
import 'package:fizzle/user_chat/presentation/chat_bloc.dart';
import 'package:fizzle/user_chat/presentation/delete_message_bloc.dart';
import 'package:fizzle/user_chat/presentation/get_chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/presentation/components/common_widgets.dart';
import '../../core/util/encryption.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String id;
  final String publicKey;
  final String myPrivateKey;

  const ChatScreen(
      {super.key,
      required this.userName,
      required this.id,
      required this.publicKey ,
      required this.myPrivateKey ,
      });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final scrollController = ScrollController();

  ChatBloc? chatBloc;
  GetChatBloc? getChatBloc;
  DeleteMsgBloc? deleteMsgBloc;

  List<dynamic> _messages = [];
  bool isLoadingChat = false;

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    initView();
  }


  void initView() async {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    getChatBloc = BlocProvider.of<GetChatBloc>(context);
    deleteMsgBloc = BlocProvider.of<DeleteMsgBloc>(context);

    getChatBloc!.add(FetchGetChatsEvent( id: widget.id));
  }

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
            } else if (state is GetChatsLoadingState) {
              setState(() {
                isLoadingChat = true;
              });
            } else if (state is GetChatsSuccessState) {
              setState(() {
                isLoadingChat = false;
                _messages = state.chatData;
              });

              // decryptMessages();
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
        ),
        BlocListener<DeleteMsgBloc, DeleteMsgState>(
          listener: (context, state) async {
            if (state is DeleteMsgErrorState) {
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
            } else if (state is DeleteMsgSuccessState) {}
          },
        ),
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
                        return InkWell(
                          onLongPress: () {
                            _showMessageOptionsDialog(index);
                          },
                          child: ListTile(
                            title: Align(
                              alignment:
                                  currentUser?.uid == _messages[index].userId
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  if (currentUser?.uid ==
                                      _messages[index].userId)
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FutureBuilder<String>(
                                          future: _decryptMessage(_messages[index].text, widget.myPrivateKey),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text('Error decrypting message');
                                            } else {
                                              return Text(
                                                snapshot.data ?? '',
                                                style: const TextStyle(color: Colors.white),
                                              );
                                            }
                                          },
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
                          ),
                        );
                      },
                    )
                  : Center(
                      child: isLoadingChat
                          ? const LoaderWidget()
                          : Text(
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
  Future<String> _decryptMessage(
      String encryptedMessage, String privateKeyPem) async {
    final privateKey = RsaKeyHelper.parsePrivateKeyFromPem(privateKeyPem);
    return RsaKeyHelper.decryptWithPrivateKey(encryptedMessage, privateKey);
  }
  late bool isDeleteAll;

  Future<void> _sendMessage(String messageText) async {
    final newMessage = Message(
      userId: widget.id,
      text: messageText,
      time: DateTime.now(),
    );
    chatBloc!.add(SendMessageEvent(
        message: newMessage, receiverPublicKey: widget.publicKey));
    _messageController.clear();
  }

  void _showMessageOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: regularText('More Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  deleteForAll(index, false);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: regularText('Delete for me'),
                ),
              ),
              if (currentUser?.uid != _messages[index].userId)
                InkWell(
                  onTap: () {
                    deleteForAll(index, true);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: regularText('Delete for all'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void deleteForAll(msgNum, isDeleteAll) {
    deleteMsgBloc?.add(DeleteMsgEvent(_messages[msgNum], isDeleteAll));
  }
}
