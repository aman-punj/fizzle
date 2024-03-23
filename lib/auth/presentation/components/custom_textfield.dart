import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isShowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: isShowing,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            icon: Icon(widget.icon, color: Colors.grey),
            suffixIcon: widget.isPassword == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isShowing = !isShowing;
                      });
                    },
                    icon: Icon(
                        isShowing ? Icons.visibility_off : Icons.visibility))
                : null),
        validator: widget.validator,
      ),
    );
  }
}
