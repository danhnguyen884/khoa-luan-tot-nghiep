class User{
  final String uid;


  User({this.uid});
}
UserData getUserData(String name){
  return UserData(name: name,email: '${name}\@email.com');
}
class UserData {

  //String uid;
  String name;
  String email;
  //String username;
  //String status;
  //int state;
  //String profilePhoto;
  UserData({
    //this.uid,
    this.name,
    this.email,
    // this.username,
    // this.status,
    // this.state,
    // this.profilePhoto,
  });
  Map toMap(UserData user) {
    var data = Map<String, dynamic>();
    //data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    // data['username'] = user.username;
    // data["status"] = user.status;
    // data["state"] = user.state;
    // data["profile_photo"] = user.profilePhoto;
    return data;
  }

  // Named constructor
  UserData.fromMap(Map<String, dynamic> mapData) {
    //this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    // this.username = mapData['username'];
    // this.status = mapData['status'];
    // this.state = mapData['state'];
    // this.profilePhoto = mapData['profile_photo'];
  }

}