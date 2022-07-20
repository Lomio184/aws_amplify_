import 'package:awspro/analytics_events.dart';
import 'package:awspro/analytics_service.dart';
import 'package:awspro/auth_credentials.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key, 
  required this.shouldShowLogin, 
  required this.didProvideCredentials }) : super(key: key);
  final VoidCallback shouldShowLogin;
  final ValueChanged<SignUpCredentials> didProvideCredentials;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _username = TextEditingController();
  final _pw       = TextEditingController();
  final _email    = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal : 40),
        child : Stack(
          children: [
            _signUpForm(),
            Container(
              alignment: Alignment.bottomCenter,
              child : FlatButton(
                onPressed: widget.shouldShowLogin,
                child : Text('Already have an account? Login'),
              )
            )
          ],
        )
      )
    );
  }
  _signUpForm() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextField(
        controller: _username,
        decoration: InputDecoration(icon : Icon(Icons.person), labelText: 'UserName'),
      ),
      TextField(
        controller: _email,
        decoration: InputDecoration(icon : Icon(Icons.mail), labelText: 'Email'),
      ),
      TextField(
        controller: _pw,
        decoration: InputDecoration(icon : Icon(Icons.lock_open), labelText: 'Password'),
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
      FlatButton(
        onPressed: _signUp,
        child: Text('Sign Up'),
        color : Theme.of(context).accentColor
      )
    ],
  );

  _signUp() {
    AnalyticsService.log(SignUpEvent());
    final username = _username.text.trim();
    final pw       = _pw.text.trim();
    final email    = _email.text.trim();

    print('user : $username');
    print('email : $email');
    print('pw : $pw');
    final credentials = SignUpCredentials(username: username, password: pw, email: email);
    widget.didProvideCredentials(credentials);
  }
}