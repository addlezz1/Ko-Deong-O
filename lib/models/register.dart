class Register {
  final String userID;
  final String password;
  final String confirmPassword;

  Register({this.userID, this.password, this.confirmPassword});
  Register.fromMap(Map<String, dynamic> data):
        userID = data["userid"],
        password = data["password"],
        confirmPassword = '1';
  static Register fromData(Map<String,dynamic>data){
    return Register.fromMap(data);
  }

}