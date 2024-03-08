import 'dart:convert';

import 'package:flutter/material.dart';
import '../map/frame.dart';
import '../../static/services/user_service.dart';
import '../../static/widgets/auth_input_decoration.dart';
import '../../static/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> signInCallback;
  const RegisterScreen({Key? key, required this.formKey, required this.signInCallback}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> formKey;

  String? _displayName, _email, _password, _firstName, _lastName, _verifyPassword;
  String? _error, _birthdayError;

  bool loadingAuth = false;

  void registerUser() async {
    print("run");
    var res = await UserService().attemptSignUp(
        email: _email!,
        password: _password!,
        firstName: _firstName!,
        lastName: _lastName!,
        displayName: _displayName!,
    );
    if(res.statusCode == 200) {
      var json = jsonDecode(res.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('signedIn', true);
      prefs.setString('id', json['id'].toString());
      Navigator.push(context, MaterialPageRoute(builder:(context) => Frame(id: json['id'])));
    } else if(res.statusCode == 203) {
      print(jsonDecode(res.body)['error']);
      setState(() {
        loadingAuth = false;
        if(jsonDecode(res.body)['error'] == 'email') {
          _error = 'Email already exists';
        }
        if (jsonDecode(res.body)['error'] == 'username') {
          _error = 'Username already exists';
        }
      });
    } else {
      loadingAuth = false;
      _error = 'Error signing up';
    }
  }



  @override
  void initState() {
    formKey = widget.formKey;
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return loadingAuth
        ? LoadingWidget()
        :GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Sign Up'), backgroundColor: Colors.black,),
      body: Center(
          child: Form(
            key: formKey,
            child: ListView(
              cacheExtent: 10000,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 50,),

                textField('_firstName', 'First Name', false, _firstName),
                textField('_lastName', 'Last Name', false, _lastName),
                textField('_displayName', 'Display Name', false, _displayName),
                textField('_email', 'Email', false, _email),
                textField('_password', 'Password', true, _password),
                textField('_verifyPassword', 'Confirm Password', true, _verifyPassword),

                Visibility(
                  visible: _error != null,
                  child: Center(child: Text(_error ?? '', style: const TextStyle(color: Colors.red),)),
                ),
                const SizedBox(height: 20,),

                signUpButton(),

                TextButton(
                    onPressed: () {
                      widget.signInCallback(true);
                    },
                    child: const Text(
                      'Already have an account? click here sign In',
                      style: TextStyle(color: Colors.blue),
                    )
                ),
                const SizedBox(height: 50,)
              ],),
          ),
      ),
    ),
        );
  }



  Widget textField(String? val, String hintText, bool obscureText, String? initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0, vertical: 15),
      child: TextFormField(
        maxLength: val == '_email' ? null : 30,
        style: const TextStyle(color: Colors.white),
        initialValue: initialValue,
        obscureText: obscureText,
        decoration: textInputDecoration(hintText),
        validator: (value) {
          if(value == null || value.isEmpty || value.trim() == '') {
            return 'field must be filled';
          }
          if(val == '_firstName') {
            if(value.trim().length > 30) {
              return 'maximum of 30 characters';
            }
            if(value.trim().length < 2) {
              return 'must have more then 2 characters';
            }
          }
          if(val == '_lastName') {
            if(value.trim().length > 30) {
              return 'maximum of 30 characters';
            }
            if(value.trim().length < 2) {
              return 'must have at least 2 characters';
            }
          }
          if(val == '_username') {
            if(value.trim().length > 30) {
              return 'maximum of 30 characters';
            }
            if(value.trim().length < 4) {
              return 'must have at least 4 characters';
            }
          }
          if(val == '_displayName') {
            if(value.trim().length > 30) {
              return 'maximum of 30 characters';
            }
            if(value.trim().length < 4) {
              return 'must have at least 4 characters';
            }
          }
          if(val == '_email') {
            bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value.trim());
            if(!emailValid) {
              return 'invalid email';
            }
          }
          if(val == '_password') {
            if(value.trim().length < 6) {
              return 'must have at least 6 characters';
            }
            if(value.trim().length > 30) {
              return 'maximum of 30 characters';
            }
            final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,$()/?]+$');
            if(validCharacters.hasMatch(value.trim()) == false) {
              return 'must be numbers, letters or "_-=@,\$()/?"';
            }
          }
          if(val == '_verifyPassword') {
            if(value.trim() != _password) {
              return 'passwords do not match';
            }
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            if(val == '_firstName') _firstName = value.trim();
            if(val == '_lastName') _lastName = value.trim();
            if(val == '_displayName') _displayName = value.trim();
            if(val == '_email') _email = value.trim();
            if(val == '_password') _password = value.trim();
            if(val == '_verifyPassword') _verifyPassword = value.trim();
          });
        },
      ),
    );
  }



  Center signUpButton() {
    return Center(
      child: SizedBox(
        height: 40,
        width: 80,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: const Center(
                child: Text('Sign up', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700),)
            ),
            onTap: () {
                setState(() {
                  _birthdayError = 'enter birthdate';
                });

              if (formKey.currentState!.validate()) {
                  setState(() {
                    loadingAuth = true;
                  });
                  registerUser();
              }
            },
          ),
        ),
      ),
    );
  }
}
