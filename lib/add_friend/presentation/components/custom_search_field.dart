import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatSearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const ChatSearchField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(horizontal: 10.w , vertical:  10.h),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10.0.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search user',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
