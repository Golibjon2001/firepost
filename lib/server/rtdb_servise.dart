
import 'package:firebase_database/firebase_database.dart';
import 'package:firepost/model/post_model.dart';

class RTDBServise{

  static final _databese=FirebaseDatabase.instance.reference();

  static Future<Stream<Event>> addPost(Post post) async{
    _databese.child('post').push().set(post.toJson());
    return _databese.onChildAdded;
  }
  static Future<List<Post>> getPost(String id) async{
    List<Post> itms=[];
    Query _query=_databese.reference().child('post').orderByChild('userId').equalTo(id);
    var snapshot=await _query.once();
    var result=snapshot.value.values as Iterable;

    for(var item in result){
      itms.add(Post.fromJson(Map <String,dynamic>.from(item)));
    }
    return itms;
  }
}