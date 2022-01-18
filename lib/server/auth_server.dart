

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/siginin_page.dart';
import 'package:firepost/server/prefs_user.dart';
import 'package:flutter/cupertino.dart';

class AuthServer{
  static final _auth=FirebaseAuth.instance;

  static Future<FirebaseUser?> siginInUser(BuildContext context,String email,String password)async{
    try{
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user= await _auth.currentUser();
      print(user.toString());
      return user;
    }catch(e){
      print(e);
    }
    return null;
  }

  static Future<FirebaseUser?> siginUpUser(BuildContext context,String name,String email,String password)async{
    try{
      var authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=authResult.user;
      print(user.toString());
      return user;
    } catch(e){
      print(e);
    }
    return null;
  }

  static void signOutUser(BuildContext context){
    _auth.signOut();
    Prefs.removeUserId().then((value) => {
      Navigator.pushReplacementNamed(context,Sigin_In.id),
    });
  }
}