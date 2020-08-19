class Profile {
  final String memberSeq;
  final String campusSeq;
  final String userID;
  final String userName;
  final String classSeq;
  final String nickName;
  final String studentImage;
  final String schoolGrade;


  Profile({this.memberSeq, this.campusSeq, this.userID, this.userName, this.classSeq, this.nickName, this.studentImage, this.schoolGrade});
  Profile.fromMap(Map<String, dynamic> data):
        memberSeq = data["member_seq"],
        campusSeq = data["campus_seq"],
        userID = data["userid"],
        userName = data["user_name"],
        classSeq = data["class_seq"],
        nickName = data["nickname"],
        studentImage = data["photo"],
        schoolGrade = data["school_grade"];

  static Profile fromData(Map<String,dynamic> data){
    return Profile.fromMap(data);
  }

}