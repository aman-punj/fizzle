import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../add_friend/presentation/components/custom_search_field.dart';


class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final chatSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: Column(
        children: [
          ChatSearchField(
            controller: chatSearchController,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) => Card(
                        margin: EdgeInsets.all(4.h),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text('A'),
                          ),
                          title: const Text('name'),
                          subtitle: const Text('last message'),
                          onTap: () {},
                        ),
                      )))
        ],
      ),
    );
  }
}
