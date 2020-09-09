class Register {
  final String status;

  Register({this.status,});
  Register.fromMap(Map<String, dynamic> status):
        status = status[0];
  static Register fromData(Map<String,dynamic>data){
    return Register.fromMap(data);
  }

}