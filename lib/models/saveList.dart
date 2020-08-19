class SaveList {
  final String unitSeq;
  final String vocaSeq;
  final String vocaEng;
  final String vocaKor;
  bool isSaved;

  SaveList({this.unitSeq, this.vocaSeq, this.vocaEng, this.vocaKor, this.isSaved});

  SaveList.fromMap(Map<String, dynamic> data):
        unitSeq = data["unit_seq"],
        vocaSeq = data["voca_seq"],
        vocaEng = data["voca_eng"],
        vocaKor = data["voca_kor"],
        isSaved = (data["is_saved"] == '1')? true : false;

  static List<SaveList> fromData(List<Map<String,dynamic>> data){
    return data.map((saveList) => SaveList.fromMap(saveList)).toList();
  }

}