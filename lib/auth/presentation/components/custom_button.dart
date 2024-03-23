import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatefulWidget {
  const CustomTextButton({
    super.key,
    required this.onPress,
    required this.title,
    this.isFilled = false,
  });

  final VoidCallback onPress;
  final String title;
  final bool isFilled;

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        height: 40.h,
        width: 1.sw,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        decoration: BoxDecoration(
          color: widget.isFilled ? Colors.lightBlue : Colors.transparent,
          border: Border.all(color: Colors.lightBlue),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: widget.isFilled ? Colors.white : Colors.lightBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp
            ),
          ),
        ),
      ),
    );
  }
}
