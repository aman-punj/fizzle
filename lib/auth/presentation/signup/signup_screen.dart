import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart' as pointy_castle;

import '../../../core/util/encryption.dart';
import 'signup_bloc.dart';
import '../../../core/presentation/components/common_widgets.dart';
import '../components/custom_button.dart';
import '../../../core/routes/send_route.dart';
import '../components/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  SignUpBloc? signUpBloc;

  @override
  void initState() {
    super.initState();
    initView();
  }

  void initView() async {
    signUpBloc = BlocProvider.of<SignUpBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) async {
            if (state is SignUpErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.msg)));
            }
            // if (state is SignUpLoadingState) {
            //   showDialog(
            //     context: context,
            //     barrierDismissible: false,
            //     builder: (BuildContext context) {
            //       return const LoaderWidget();
            //     },
            //   );
            // }
            if (state is SignUpSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.msg)));
              sendRoute(context, RoutesNames.allChatsHomeScreen,
                  clearStack: true, isReplace: false);
            }
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign UP ',
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
                    icon: Icons.mail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
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
                  CustomTextField(
                    controller: nameController,
                    hintText: 'Your name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomTextButton(
                    onPress: _signUp,
                    title: 'Sign up',
                    isFilled: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      regularText('Already have a account! '),
                      GestureDetector(
                        onTap: () {
                          sendRoute(context, RoutesNames.loginScreen,
                              clearStack: true, isReplace: false);
                        },
                        child: regularText('Login', Colors.lightBlue),
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


  static const storage = FlutterSecureStorage();

  Future<void> _generateAndStoreKeys() async {
    // Generate RSA key pair
    final keyPair = await RsaKeyHelper.computeRSAKeyPair();
    final pointy_castle.RSAPublicKey publicKey =
    keyPair.publicKey as pointy_castle.RSAPublicKey;
    final pointy_castle.RSAPrivateKey privateKey =
    keyPair.privateKey as pointy_castle.RSAPrivateKey;

    // Convert keys to PEM format
    final publicKeyPem = RsaKeyHelper.encodePublicKeyToPemPKCS1(publicKey);
    final privateKeyPem = RsaKeyHelper.encodePrivateKeyToPemPKCS1(privateKey);

    // Store keys securely
    await storage.write(key: 'publicKey', value: publicKeyPem);
    await storage.write(key: 'privateKey', value: privateKeyPem);

    print('Public key: $publicKeyPem');
    print('Private key: $privateKeyPem');
  }

  void _signUp() async {
    await _generateAndStoreKeys();
    String? pkey = await storage.read(key: 'publicKey');
    print(pkey);
    String? p2key = await storage.read(key: 'privateKey');
    print(p2key);
    if (_formKey.currentState!.validate() && pkey != null) {
      signUpBloc?.add(DoSignUpEvent(
        email: emailController.text,
        password: passwordController.text,
        userName: nameController.text,
        publicKey: pkey,
      ));
    }
  }
}
