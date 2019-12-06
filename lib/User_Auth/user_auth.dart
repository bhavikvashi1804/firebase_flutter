import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth extends StatefulWidget {

  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GoogleSignIn googleSignIn=GoogleSignIn();


  Future<FirebaseUser> _signIn() async {

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print( 'signInWithGoogle succeeded: $user');


    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User Signed out");
  }


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
                onPressed: (){
                  _signIn();
                },
              ),
              RaisedButton(
                child: Text('Log out'),
                onPressed: (){
                  _signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
