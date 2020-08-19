class TestResult {
  final String memberSeq;
  final String classSeq;
  final String unitSeq;
  final String testCode;
  final String seq;
  final String answer;
  final String word;

  TestResult({this.memberSeq, this.classSeq, this.unitSeq, this.testCode, this.seq, this.answer, this.word});

  TestResult.fromMap(Map<String, dynamic> data):
    memberSeq = data["member_seq"],
    classSeq = data["class_seq"],
    unitSeq = data["unit_seq"],
    testCode = data["test_code"],
    seq = data["seq"],
    answer = data["answer"],
    word = data["word"];

  static TestResult fromData(Map<String,dynamic> data){
    return TestResult.fromMap(data);
  }

}