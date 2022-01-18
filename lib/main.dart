
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/deteil_page.dart';
import 'package:firepost/pages/hom_page.dart';
import 'package:firepost/pages/siginin_page.dart';
import 'package:firepost/pages/siginup_page.dart';
import 'package:firepost/server/prefs_user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget _startPage(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext contex,snapshot) {
        if(snapshot.hasData){
          Prefs.saveUserId(snapshot.data!.uid);
          return Hom_page();
        }else{
          Prefs.removeUserId();
          return Sigin_In();
        }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:_startPage(),
      routes: {
        Sigin_In.id:(context)=>Sigin_In(),
        Sigin_Up.id:(context)=>Sigin_Up(),
        Hom_page.id:(contex)=>Hom_page(),
        Detail_Page.id:(contex)=>Detail_Page(),
      },
    );
  }
}

