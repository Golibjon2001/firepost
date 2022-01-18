class Post{
  String userId;
  String title;
  String content;
  String img_url;
  Post(this.userId, this.title,this.content,this.img_url);

  Post.fromJson(Map<String,dynamic>json)
        :userId=json['userId'],
        title=json['title'],
        img_url=json['img_url'],
        content=json['content'];

   Map<String,dynamic> toJson()=>{
     'userId':userId,
     'title':title,
     'content':content,
     'img_url':img_url,
   };
}