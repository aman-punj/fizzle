import 'package:fizzle/auth/presentation/signup/signup_bloc.dart';
import 'package:fizzle/auth/data/auth_repo.dart';
import 'package:fizzle/auth/presentation/login/login_screen.dart';
import 'package:fizzle/auth/presentation/signup/signup_screen.dart';
import 'package:fizzle/user_chat/presentation/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../add_friend/data/user_repo.dart';
import '../../add_friend/presentation/add_friend_screen/add_friend_screen.dart';
import '../../add_friend/presentation/add_friend_screen/user_bloc.dart';
import '../../all_chat_home_page/presentation/all_chats_screen.dart';
import '../../auth/presentation/splash/splash_screen.dart';
import '../../auth/presentation/login/login_bloc.dart';

dynamic sendRoute(BuildContext context, RoutesNames s,
    {bool isReplace = false,
    bool clearStack = false,
    Function? onRefresh,
    Map<String, dynamic>? data}) {
  dynamic widget;
  switch (s) {
    case RoutesNames.splash:
      widget = const SplashScreen();
      break;

    case RoutesNames.allChatsHomeScreen:
      sendActivity(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                  create: (context) => (UserBloc(UserRepository()))),
            ],
            child: const AllChatsScreen(),
          ),
          isReplace: isReplace,
          clearStack: clearStack);
      break;
    case RoutesNames.addFriend:
      sendActivity(
        context,
        MultiBlocProvider(
          providers: [
            BlocProvider<UserBloc>(
                create: (context) => (UserBloc(UserRepository()))),
          ],
          child: const AddUserScreen(),
        ),
      );
      break;

    case RoutesNames.loginScreen:
      sendActivity(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider<LoginScreenBloc>(
                  create: (context) => (LoginScreenBloc(
                      firebaseAuthService: FirebaseAuthService()))),
            ],
            child: const LoginScreen(),
          ),
          isReplace: isReplace,
          clearStack: clearStack);
      break;
      // case RoutesNames.chatScreen:
      // sendActivity(
      //     context, const ChatScreen(userName: 'asd' , id: ' ' ),
      //     );
      // break;

    case RoutesNames.signupScreen:
      sendActivity(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider<SignUpBloc>(
                  create: (context) =>
                      (SignUpBloc(firebaseAuthService: FirebaseAuthService()))),
            ],
            child: const SignUpScreen(
                // data: data,
                ),
          ),
          isReplace: isReplace,
          clearStack: clearStack);
      break;
  }
  return widget;
}

enum RoutesNames { splash, allChatsHomeScreen, addFriend, loginScreen, signupScreen  }

sendActivity(BuildContext context, Widget funcs,
    {bool isReplace = false, Function? onRefresh, bool clearStack = false}) {
  if (clearStack) {
    return Navigator.pushAndRemoveUntil(
        context,
        PageTransition(type: PageTransitionType.rightToLeft, child: funcs),
        (route) => false);
  } else if (isReplace) {
    return Navigator.pushReplacement(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: funcs),
    ).then((value) {
      if (onRefresh != null) {
        onRefresh();
      }
      return value;
    });
  } else {
    return Navigator.push(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: funcs),
    ).then((value) {
      if (onRefresh != null) {
        onRefresh();
      }
      return value;
    });
  }
}
