import 'package:firepost/model/post_model.dart';
import 'package:firepost/pages/deteil_page.dart';
import 'package:firepost/server/auth_server.dart';
import 'package:firepost/server/prefs_user.dart';
import 'package:firepost/server/rtdb_servise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Hom_page extends StatefulWidget {
  static final String id="hom_page";
  const Hom_page({Key? key}) : super(key: key);

  @override
  _Hom_pageState createState() => _Hom_pageState();
}
class _Hom_pageState extends State<Hom_page> {
  List<Post> itms=[];
   var isLoding=false;


  Future _openDeteil()async{
    Map result= await Navigator.of(context).push(new MaterialPageRoute(
        builder:(BuildContext context){
          return new Detail_Page();
        }
    ));
    if(result !=null&& result.containsKey('dada')){
      print(result['data']);
      _apiGetPost();
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPost();
  }
  _apiGetPost()async{
    setState(() {
      isLoding=true;
    });
    var id=await Prefs.loadUserId();
    RTDBServise.getPost(id).then((post) => {
      _resPost(post),
    });
  }

  _resPost(List<Post>post){
    setState(() {
      isLoding=false;
      itms=post;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Add Post'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:(){
              AuthServer.signOutUser(context);
            },
            icon: Icon(Icons.exit_to_app,color: Colors.white,),
          ),
        ],
      ),
      body:Stack(
        children: [
          ListView.builder(
              itemCount:itms.length,
              itemBuilder:(ctx,i){
                return ofList(itms[i]);
              }
          ),
          isLoding?
              Center(
                child:CircularProgressIndicator(),
              ):SizedBox.shrink(),

        ],
      ),
      floatingActionButton:FloatingActionButton(
        onPressed:(){
          _openDeteil();
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget ofList(Post post){
    return Container(
      padding:EdgeInsets.all(20),
      child:Row(
        children: [
          Container(
            height:70,
            width:70,
            child:post.img_url!=null?
                Image.network(post.img_url,fit:BoxFit.cover,):
            Image.asset('assets/images/ic_defould.png'),
          ),
          SizedBox(width:15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title,style:TextStyle(color:Colors.black,fontSize: 20),),
              SizedBox(height: 10,),
              Text(post.content,style:TextStyle(color:Colors.black,fontSize: 15),),
            ],
          ),
        ],
      ),
    );
  }

}
