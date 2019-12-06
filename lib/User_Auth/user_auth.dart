import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth extends StatefulWidget {
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Auth'),),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Log In'),
                onPressed: (){},
              ),
              RaisedButton(
                child: Text('Log out'),
                onPressed: (){},
              )
            ],
          ),
        ),
      ),
    );
  }
}
