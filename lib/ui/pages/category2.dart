import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:talkwho/models/category.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/models/book.dart';
import 'package:talkwho/ui/pages/category.dart';
import 'category3.dart';

class Category2Page extends StatefulWidget {
  final Category category;
  const Category2Page({Key key, this.category}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Category2Page> {

  List<Book> units = List(999);

  void _getUnit() async {
    List<Book> unit =  await getBook(widget.category.cateSeq);
    if(this.mounted) {
      setState(() {
        units = unit;
      });
    }
  }

  @override
  Widget build(BuildContext context){

    _getUnit();
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => CategoryPage()
        ),);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back, color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => CategoryPage()
              ));
            },
          ),
          title: AutoSizeText(
            widget.category.title +'의 세트를 지정해주세요',
            minFontSize: 10.0,
            maxLines: 1,
            wrapWords: false,
          ),
          elevation: 0,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.white70,
                  Colors.lightBlueAccent
                ],
                begin: const FractionalOffset(0.5, 0.5),
                end: const FractionalOffset(0.5, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: SafeArea(
            child: AnimationLimiter(
              child: GridView.count(
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 3,
                children: List.generate(
                  units.length, (index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 3,
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: FadeInAnimation(
                          child: _buildCategoryItem(context, index)
                      ),
                    ),
                  );
                },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {

    Book book = units[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: new MaterialButton(
        elevation: 1.0,
        highlightElevation: 1.0,
        onPressed: () => _categoryPressed(context, book),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        textColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              book?.bookName == null ? '' : book.bookName,
              minFontSize: 10.0,
              textAlign: TextAlign.center,
              maxLines: 3,
              wrapWords: false,),
          ],
        ),
      ),
    );
  }

  _categoryPressed(BuildContext context,Book book) {

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => Category3Page(book: book, category : widget.category)
      ));
  }
}