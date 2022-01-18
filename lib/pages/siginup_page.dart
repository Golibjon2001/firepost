import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/hom_page.dart';
import 'package:firepost/pages/siginin_page.dart';
import 'package:firepost/server/auth_server.dart';
import 'package:firepost/server/prefs_user.dart';
import 'package:firepost/server/utils_server.dart';
import 'package:flutter/material.dart';
class Sigin_Up extends StatefulWidget {
  static final String id="sigin_up";
  const Sigin_Up({Key? key}) : super(key: key);

  @override
  _Sigin_UpState createState() => _Sigin_UpState();
}

class _Sigin_UpState extends State<Sigin_Up> {
   var isLoading=false;
  var namecontroler=TextEditingController();
  var emailcontroler=TextEditingController();
  var passwordcontroler=TextEditingController();

  void _dologinUp(){
    String name=namecontroler.text.toString().trim();
    String email=emailcontroler.text.toString().trim();
    String password=passwordcontroler.text.toString().trim();
    if(name.isEmpty||email.isEmpty||password.isEmpty) return;
    setState(() {
      isLoading=true;
    });

    AuthServer.siginUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser!),
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser)async{
    setState(() {
      isLoading=false;
    });
    await Prefs.saveUserId(firebaseUser.uid);
    if(firebaseUser!=0){
      Navigator.pushReplacementNamed(context,Hom_page.id);
    }else{
      Utils.fireToast('chek your informations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Container(
            padding: EdgeInsets.only(right: 15,left: 15),
            margin: EdgeInsets.only(right: 15,left:15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller:namecontroler,
                  decoration: InputDecoration(
                    hintText: "Fulname",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller:emailcontroler,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText:true,
                  controller:passwordcontroler,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 45,
                  width: double.infinity,
                  color: Colors.blue,
                  child: FlatButton(
                    onPressed: (){
                      _dologinUp();
                    },
                    child: Text("Sign Up",style:TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context,Sigin_In.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Alerady have an account?"),
                        SizedBox(width: 10,),
                        Text("Sigin Up"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading?
          Center(
            child: CircularProgressIndicator(),
          ):SizedBox.shrink(),
        ],
      ),
    );
  }
}
