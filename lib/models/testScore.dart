class TestScore {
  final String unitName;
  final String unitSeq;
  final String memberSeq;
  final String classSeq;
  final String testCode;
  final String score;
  final String result;
  final String registDate;

  TestScore({this.unitName, this.unitSeq, this.memberSeq, this.classSeq, this.testCode, this.score, this.result, this.registDate});
  TestScore.fromMap(Map<String, dynamic> data):
        unitName = data["unit_name"],
        unitSeq = data["unit_seq"],
        memberSeq = data["member_seq"],
        classSeq = data["class_seq"],
        testCode = data["test_code"],
        score = data["score"],
        result = data["result"],
        registDate = data["regist_date"];

  static List<TestScore> fromData(List<Map<String,dynamic>> data){
    return data.map((question) => TestScore.fromMap(question)).toList();
  }
}