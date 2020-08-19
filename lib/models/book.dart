class Book {
  final String bookSeq;
  final String bookName;
  final String category;
  final String bookImage;

  Book({this.bookSeq, this.bookName,  this.bookImage, this.category});
  Book.fromMap(Map<String, dynamic> data):
        bookSeq = data["book_seq"],
        bookName = data["book_name"],
        bookImage = data["book_image"],
        category = data["cate_seq"];
  static List<Book> fromData(List<Map<String,dynamic>> data){
    return data.map((question) => Book.fromMap(question)).toList();
  }
}