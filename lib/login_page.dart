import 'package:awspro/analytics_events.dart';
import 'package:awspro/analytics_service.dart';
import 'package:awspro/auth_credentials.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key, required this.shouldShowSignUp, required this.didProvideCredentials }) : super(key: key);
  final VoidCallback shouldShowSignUp;
  final ValueChanged<LoginCredentials> didProvideCredentials;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = new TextEditingController();
  final _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(
        minimum: EdgeInsets.symmetric(horizontal : 40),
        child : Stack(
          children: [
            _loginForm(),
            Container(
              alignment : Alignment.bottomCenter,
              child : FlatButton(
                onPressed: widget.shouldShowSignUp,
                child : Text("Don't have an account? Sign Up!")
              )
            )
          ],
        )
      )
    );
  }
  Widget _loginForm() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextField(
        controller: _username,
        decoration: InputDecoration(
          icon : Icon(Icons.lock_open,),
          labelText : 'UserName'
        ),
        obscureText: true,
        keyboardType: TextInputType.name,
      ),
      TextField(
        controller: _password,
        decoration: InputDecoration(
          icon : Icon(Icons.lock_open,),
          labelText : 'Password'
        ),
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
      FlatButton(
        onPressed: _login,
        child : Text('Login'),
        color : Theme.of(context).accentColor
      )
    ],
  );
  _login() {
    AnalyticsService.log(LoginEvent());
    final username = _username.text.trim();
    final pw       = _password.text.trim();

    print('username : $username');
    print('pw       : $pw');
    final credentials = LoginCredentials(username: username, password: pw);
    widget.didProvideCredentials(credentials);
  }
}