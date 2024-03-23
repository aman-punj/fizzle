import 'package:firebase_auth/firebase_auth.dart';
import 'package:fizzle/user_chat/modal/chat_rapo.dart';
import 'package:fizzle/user_chat/presentation/chat_bloc.dart';
import 'package:fizzle/user_chat/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes/send_route.dart';
import '../../add_friend/presentation/add_friend_screen/user_bloc.dart';
import '../../add_friend/presentation/components/custom_search_field.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<AllChatsScreen> {
  final chatSearchController = TextEditingController();

  UserBloc? userBloc;

  // User? userList;

  var userList = [];

  var filteredItems = [];

  @override
  void initState() {
    super.initState();
    initView();
  }

  void initView() async {
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc?.add(UserEvent.fetchUsers);
  }

  void filterItems(String query) {
    setState(() {
      filteredItems.clear();
      filteredItems.addAll(userList.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) async {
            if (state is UsersErrorState) {
            } else if (state is UsersLoadedState) {
              setState(() {
                userList = state.users;
                filteredItems.clear();
                filteredItems.addAll(userList);
              });
            }
          },
        )
      ],
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Column(
            children: [
              ChatSearchField(
                controller: chatSearchController,
                onChanged: (value) {
                  filterItems(value);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    String firstCharacter =
                        filteredItems[index].name.substring(0, 1).toUpperCase();
                    return Card(
                      margin: EdgeInsets.all(4.h),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(firstCharacter),
                        ),
                        title: Text(filteredItems[index].name),
                        subtitle: const Text('Last message'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<ChatBloc>(
                                          create: (context) =>
                                              (ChatBloc(ChatRepository())))
                                    ],
                                    child: ChatScreen(
                                        userName: filteredItems[index].name,
                                        id: filteredItems[index].id),
                                  )));
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Welcome',
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
      ),
      actions: [
        InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              pushPage();
            },
            child: const Icon(Icons.logout)),
        SizedBox(
          width: 8.w,
        ),
        InkWell(
            onTap: () {
              sendRoute(context, RoutesNames.addFriend);
            },
            child: const Icon(Icons.add_comment_outlined)),
        SizedBox(
          width: 8.w,
        )
      ],
    );
  }

  void pushPage() {
    sendRoute(context, RoutesNames.loginScreen);
  }
}
