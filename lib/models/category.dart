class Category {
  final String cateSeq;
  final String parentSeq;
  final String title;
  final String schoolGrade;

  Category({this.cateSeq, this.parentSeq, this.title, this.schoolGrade});
  Category.fromMap(Map<String, dynamic> data):
        cateSeq = data["cate_seq"],
        parentSeq = data["parent_seq"],
        title = data["title"],
        schoolGrade = data["school_grade"];
  static List<Category> fromData(List<Map<String,dynamic>> data){
    return data.map((question) => Category.fromMap(question)).toList();
  }
}