import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/send_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    initView();
  }

  void initView() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Timer(const Duration(seconds: 3), () {
        sendRoute(context, RoutesNames.allChatsHomeScreen,
            isReplace: false, clearStack: true);
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        sendRoute(context, RoutesNames.loginScreen,
            isReplace: false, clearStack: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/F logo.jpg'),
      ),
    );
  }
}
