class Unit {
  final String unitSeq;
  final String unitName;
  final String score;
  final String category;

  Unit({this.unitSeq, this.unitName,  this.score, this.category});
  Unit.fromMap(Map<String, dynamic> data):
        unitSeq = data["unit_seq"],
        unitName = data["unit_name"],
        score = data["score"],
        category = data["category"];
  static List<Unit> fromData(List<Map<String,dynamic>> data){
    return data.map((question) => Unit.fromMap(question)).toList();
  }

}