import 'package:fizzle/core/presentation/components/common_widgets.dart';
import 'package:fizzle/auth/presentation/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes/send_route.dart';
import '../components/custom_textfield.dart';
import 'login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreenBloc? loginScreenBloc;

  final _formKey = GlobalKey<FormState>();

  bool isShowing = false;

  @override
  void initState() {
    super.initState();
    initView();
  }

  void initView() async {
    loginScreenBloc = BlocProvider.of<LoginScreenBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final loginScreenBloc = BlocProvider.of<LoginScreenBloc>(context);

    return MultiBlocProvider(
      providers: [
        BlocListener<LoginScreenBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.msg)));
            }/*if (state is LoginInitialState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const LoaderWidget();
                },
              );
            }
            if (state is LoginLoadingState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const LoaderWidget();
                },
              );
            }*/
            if (state is LoginSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.msg)));
             sendRoute(context, RoutesNames.allChatsHomeScreen , clearStack: true ,isReplace: false);
            }
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(10.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 300.h,
                    child: Image.asset('assets/images/F logo.jpg'),
                  ),
                  CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      icon: Icons.mail , validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: Icons.password,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomTextButton(
                    onPress: _login,
                    title: 'Log IN',
                    isFilled: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      regularText('Don\'t have a account? '),
                      GestureDetector(
                        onTap: () {
                          sendRoute(context, RoutesNames.signupScreen,
                              clearStack: true, isReplace: false);
                        },
                        child: regularText('Sign UP', Colors.lightBlue),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      loginScreenBloc?.add(DoLoginEvent(
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }
}
