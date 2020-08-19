import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:talkwho/models/book.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'unit.dart';

class CurrentLearningPage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CurrentLearningPage> {

  List<Book> books = List();

  void _getUnit() async {
    List<Book> book =  await getHomeBook("1");
    if(this.mounted) {
      setState(() {
        books = book;
      });
    }
  }

  @override
  Widget build(BuildContext context){

    _getUnit();

    return Scaffold(
        appBar: AppBar(
          title: Text('eduby'),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),//배경이 웨이브
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor//배경 그림색
                ),
                height: 300,//배경 그림 높이
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                    child: Text("진행중인교재", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0
                    ),),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,//가로로 정렬된 도형의 수
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0
                      ),
                      delegate: SliverChildBuilderDelegate(
                        _buildCategoryItem,
                        childCount: books.length,//도형의 수

                      )

                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {

    Book book = books[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, book),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          SizedBox(height: 5.0),
          AutoSizeText(
            book.bookName,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,),
        ],
      ),
    );
  }
  _categoryPressed(BuildContext context,Book book) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => UnitPage( book: book,)
    ));
  }
}