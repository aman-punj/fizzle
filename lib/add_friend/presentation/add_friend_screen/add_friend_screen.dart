import 'package:fizzle/add_friend/presentation/add_friend_screen/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routes/send_route.dart';
import '../components/custom_search_field.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final chatSearchController = TextEditingController();

  UserBloc? userBloc;

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
        appBar: AppBar(
          title: Text(
            'Add new friend',
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
          ),
        ),
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
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                            ),
                            elevation: 3,
                            shadowColor: Colors.grey,
                          ),
                          child: const Text(
                            'Add Friend',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
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

  void pushPage() {
    sendRoute(context, RoutesNames.loginScreen);
  }
}
