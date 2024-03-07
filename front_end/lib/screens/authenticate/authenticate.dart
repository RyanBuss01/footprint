import 'package:flutter/material.dart';
import '../authenticate/register.dart';
import '../authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final formKey = GlobalKey<FormState>();
  bool signInScreen = true;
  bool loadingAuth = false;


  void signInCallback(bool signIn) {
    setState(() {
      signInScreen = signIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    return signInScreen

    /// Sign In Screen
        ? SignInScreen(formKey: formKey, signInCallback: signInCallback)

    /// Sign Up Screen
        : RegisterScreen(formKey: formKey, signInCallback: signInCallback);
  }
}