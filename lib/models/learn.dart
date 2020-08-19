class Learn {
  final String type;
  final String code;
  final String title;
  final String subtitle;
  final String score;

  Learn({this.type, this.code, this.title, this.subtitle, this.score});
  Learn.fromMap(Map<String, dynamic> data):
        type = data["type"],
        code = data["code"],
        title = data["title"],
        subtitle = data["subtitle"],
        score = data["score"];
  static List<Learn> fromData(List<Map<String,dynamic>> data){
    return data.map((question) => Learn.fromMap(question)).toList();
  }
}