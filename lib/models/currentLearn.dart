class CurrentLearn {
  final String memberSeq;
  final String unitSeq;
  final String bookSeq;
  final String bookIndex;
  final String unitSort;
  final String categoryName;
  final String bookName;

  CurrentLearn({this.memberSeq, this.unitSeq, this.bookSeq, this.bookIndex, this.unitSort, this.categoryName, this.bookName});

  CurrentLearn.fromMap(Map<String, dynamic> data):
    memberSeq = data["member_seq"],
    unitSeq = data["unit_seq"],
    bookSeq = data["book_seq"],
    bookIndex = data["book_index"],
    unitSort = data["unit_sort"],
    categoryName = data["category_name"],
    bookName = data["book_name"];

  static CurrentLearn fromData(Map<String,dynamic> data){
    return CurrentLearn.fromMap(data);
  }

}