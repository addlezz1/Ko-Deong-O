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
  final String bookValue;
  const Category2Page({Key key, this.category, this.bookValue}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Category2Page> {

  List<Book> units = List(999);

  void _getUnit() async {
    List<Book> unit =  await getBook(widget.category.cateSeq, widget.bookValue);
    if(this.mounted) {
      setState(() {
        units = unit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Form(
        child: (orientation == Orientation.portrait)
            ? portraitMode(context)
            : landscapeMode(context),
      ),
    );
  }

  Widget portraitMode(context){

    _getUnit();
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => CategoryPage(bookValue: widget.bookValue,)
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
                  builder: (_) => CategoryPage(bookValue: widget.bookValue,)
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
                crossAxisCount: 4,
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

  Widget landscapeMode(context){

    _getUnit();
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => CategoryPage(bookValue: widget.bookValue,)
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
                  builder: (_) => CategoryPage(bookValue: widget.bookValue,)
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
                crossAxisCount: 6,
                children: List.generate(
                  units.length, (index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 3,
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: FadeInAnimation(
                          child: _buildCategoryItemL(context, index)
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
    Size size = MediaQuery.of(context).size;
    Book book = units[index];
    return Column(
      children: <Widget>[
        Container(
          height: size.width * 0.2,
          width: size.width * 0.2,
          padding: EdgeInsets.symmetric(vertical: size.width * 0.02, horizontal: size.width * 0.02),
          child: new MaterialButton(
            elevation: 3.0,
            highlightElevation: 1.0,
            onPressed: () => _categoryPressed(context, book),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * 0.03),
            ),
            color: Colors.white,
            textColor: Colors.black,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/fish_image.png'),
            ),
          ),
        ),
        Text(
          book?.bookName == null ? '' : book.bookName,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent, fontSize: size.height * 0.015),
        ),
      ],
    );
  }

  Widget _buildCategoryItemL(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    Book book = units[index];
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.2,
          width: size.height * 0.2,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.height * 0.02),
          child: new MaterialButton(
            elevation: 3.0,
            highlightElevation: 1.0,
            onPressed: () => _categoryPressed(context, book),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.height * 0.03),
            ),
            color: Colors.white,
            textColor: Colors.black,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/fish_image.png'),
            ),
          ),
        ),
        Text(
          book?.bookName == null ? '' : book.bookName,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent, fontSize: size.width * 0.015),
        ),
      ],
    );
  }

  _categoryPressed(BuildContext context,Book book) {

    print(book.bookName);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => Category3Page(book: book, category : widget.category, bookValue : widget.bookValue)
      ));
  }
}