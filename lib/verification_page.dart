import 'package:awspro/analytics_events.dart';
import 'package:awspro/analytics_service.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({ Key? key, required this.didProvideVerificationCode }) : super(key: key);

  final ValueChanged<String> didProvideVerificationCode;
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(
        minimum: EdgeInsets.symmetric(horizontal : 40),
        child : _verificationForm(),
      )
    );
  }
  _verificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _verificationController,
          decoration: InputDecoration(
            icon : Icon(Icons.confirmation_number),
            labelText: 'Verification Code'
          ),
        ),
        FlatButton(
          onPressed: _verify,
          child : Text('Verify'),
          color : Theme.of(context).accentColor
        )
      ],
    );
  }
  _verify() {
    AnalyticsService.log(VerificationEvent());
    final verficationCode = _verificationController.text.trim();
    widget.didProvideVerificationCode(verficationCode);
  }
}