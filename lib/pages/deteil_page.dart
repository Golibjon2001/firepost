
import 'dart:io';

import 'package:firepost/model/post_model.dart';
import 'package:firepost/server/prefs_user.dart';
import 'package:firepost/server/rtdb_servise.dart';
import 'package:firepost/server/stor_servise.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Detail_Page extends StatefulWidget {
  static final String id="detail_page";
  const Detail_Page({Key? key}) : super(key: key);

  @override
  _Detail_PageState createState() => _Detail_PageState();
}

class _Detail_PageState extends State<Detail_Page> {
  var isLoding=false;
  File? _image;
  final picker= ImagePicker();
  var titlecontroller=TextEditingController();
  var contentcontroller=TextEditingController();



  void _doAdd()async{
  String title=titlecontroller.text.toString().trim();
  String content=contentcontroller.text.toString().trim();

  if(title.isEmpty||content.isEmpty) return;
  if(_image==null) return;
  _apiUploadImage(title,content);
  }
  void _apiUploadImage(String title,String content){
    setState(() {
      isLoding=true;
    });
    StorServise.uploadImage(_image!).then((img_url)=>{
      _apiAddPost(title, content, img_url!),
    });
  }

  _apiAddPost(String title,String content,String img_url )async{
    var id=await Prefs.loadUserId();
    RTDBServise.addPost(new Post(id, title, content,img_url)).then((value) => {
      _respAddPost(),
    });
  }

  _respAddPost(){
    setState(() {
      isLoding=false;
    });
    Navigator.of(context).pop({'data':'done'});
  }

   Future _getImage() async{
   final piskedFile= await picker.getImage(source: ImageSource.gallery);

   setState(() {
     if(piskedFile!=null){
       _image=File(piskedFile.path);
     }else{
       print("No image selected.");
     }
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Add Post"),
        centerTitle:true,
      ),
      body:Stack(
        children: [
          SingleChildScrollView(
            child:Container(
              height:MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: 15,right: 15),
              margin:EdgeInsets.only(left: 15,right: 15),
              child:Column(
                children: [
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap:()=>_getImage(),
                    child: Container(
                      height:100,
                      width:100,
                      child: _image !=null?
                      Image.file(_image!,fit:BoxFit.cover,):
                      Image.asset('assets/images/instagram.png'),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller:titlecontroller,
                    decoration:InputDecoration(
                      hintText:"Title",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller:contentcontroller,
                    decoration:InputDecoration(
                      hintText:"Content",
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 45,
                    width: double.infinity,
                    color:Colors.blue,
                    child:FlatButton(
                      onPressed: (){
                        _doAdd();
                      },
                      child:Text("Add",style:TextStyle(color:Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoding?
              Center(
                child:CircularProgressIndicator()
              ):SizedBox.shrink(),
        ],
      ),
    );
  }
}
