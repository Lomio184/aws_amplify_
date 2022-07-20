import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:awspro/auth_credentials.dart';
import 'package:flutter/material.dart';

enum AuthFlowStatus { login, signUp, verification, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;
  AuthState({required this.authFlowStatus});
}

class AuthService {
  late AuthCredentials _credentials;
  final authStateController = StreamController<AuthState>();

  checkAuthStatus() async {
    try {
      await Amplify.Auth.fetchAuthSession();

      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } catch (_) {
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }

  showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }
  
  showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  loginWithCredentials(AuthCredentials credentials) async {
    try {
      final result = await Amplify.Auth.signIn(
        username : credentials.username,
        password: credentials.password,
      );

      if (result.isSignedIn) {
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        print('User could not be signed in');
      } 
    } on AmplifyException catch (authError) {
      print('Could not login - ${authError.message}');
      logOut();
    }
  }

  signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email' : credentials.email};
      final resut = await Amplify.Auth.signUp(
        username : credentials.username,
        password: credentials.password,
        options: CognitoSignUpOptions(userAttributes: userAttributes));
      
      if (resut.isSignUpComplete) {
        loginWithCredentials(credentials);
      } else {
        this._credentials = credentials;

        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }
    } on AmplifyException catch (authError) {
      print('Failed to sign up - ${authError.message}');
    }  
  }

  verifyCode(String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: _credentials.username, 
        confirmationCode: verificationCode);
      if (result.isSignUpComplete) {
        loginWithCredentials(_credentials);
      } else {

      }
    } on AmplifyException catch (authError) {
      print("Could not verify code - ${authError.message}");
    }
  }

  logOut() async {
    try {
      await Amplify.Auth.signOut();

      showLogin();
    } on AmplifyException catch (authError) {
      print('Could not log out - ${authError.message}');
    }
  }

  buildRequestToLogOut(BuildContext context)  {
    return AlertDialog(
      title : Text("Login Failed"),
      content : Text("Do you want to Log Out?"),
      actions : [
        TextButton(
          onPressed: () => logOut(),
          child : Text("Ok")
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child : Text("Cancel")
        )
      ]
    );
  }
}

