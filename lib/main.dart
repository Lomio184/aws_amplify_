import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:awspro/auth_service.dart';
import 'package:awspro/camera_flow.dart';
import 'package:awspro/sign_up.dart';
import 'package:awspro/verification_page.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key ? key,
  }): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State < Home > {
  final authService = AuthService();
  final _amplify = Amplify;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService.showLogin();
    _configureAmplify();
    authService.checkAuthStatus();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <AuthState> (
      stream: authService.authStateController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Navigator(
            pages: [
              if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
                MaterialPage(child : LoginPage(
                  shouldShowSignUp : authService.showSignUp,
                  didProvideCredentials: authService.loginWithCredentials,
                )),

              if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp) 
                MaterialPage(child : SignUpPage(
                  shouldShowLogin: authService.showLogin,
                  didProvideCredentials: authService.signUpWithCredentials,
                )),
              if (snapshot.data.authFlowStatus == AuthFlowStatus.verification)
                MaterialPage(child : VerificationPage(
                  didProvideVerificationCode: authService.verifyCode),
                ),
              if (snapshot.data.authFlowStatus == AuthFlowStatus.session)
                MaterialPage(child : CameraFlow(
                  shouldLogOut: authService.logOut),
                )
            ],
            onPopPage: (route, result) => route.didPop(result),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child : CircularProgressIndicator()
          );
        }
      },
    );
  }
  _configureAmplify() async {
    _amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3(), AmplifyAnalyticsPinpoint()]);
    try {
      await _amplify.configure(amplifyconfig);
      print('Successfully configured Amplify');
    } catch (e) {
      print('Could not configure Amplify');
    }
  }
}