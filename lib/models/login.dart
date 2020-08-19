class Login {
  final String userID;
  final String password;
  final String userName;

  Login({this.userID, this.password, this.userName});
  Login.fromMap(Map<String, dynamic> data):
        userID = data["userid"],
        password = data["password"],
        userName = data["user_name"];

  static Login fromData(Map<String,dynamic>data){
    return Login.fromMap(data);
  }

}