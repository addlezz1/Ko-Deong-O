import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/ui/pages/home.dart';
import 'package:talkwho/ui/pages/main.dart';
import 'package:talkwho/ui/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/models/book.dart';
import 'learn_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/models/currentLearn.dart';

class CurrentsPage extends StatefulWidget {
  final Book book;
  const CurrentsPage({Key key, this.book}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CurrentsPage> {

  List<Unit> units = List(999);

  String _memberSeq = '';
  String _unitSeq = '';
  String _bookSeq = '';
  String _categoryName = '';
  String _bookName = '';
  int _bookIndex = 0;

  SharedPreferences _sharedPreferences;

  void _getCurrentUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String memberSeq = prefs.getString('memberSeq');
    _memberSeq = memberSeq;
    CurrentLearn currentUnit = await getCurrentUnit(_memberSeq);
    //print(currentUnit.unitSeq);
    _unitSeq = currentUnit.unitSeq;
    _bookSeq = currentUnit.bookSeq;
    _categoryName = currentUnit.categoryName;
    _bookName = currentUnit.bookName;

    if(currentUnit.bookIndex != null) {
      _bookIndex = int.parse(currentUnit.bookIndex);
      //print(_bookSeq);
    }

    if(_categoryName != '') {
      units = await getUnit(_bookSeq);
      if (this.mounted) {
        setState(() {});
      }
    }
    //print(units[_bookIndex].unitName);
    //print(units[_bookIndex].unitSeq);
  }

  void initState(){
    super.initState();
    _getCurrentUnit();
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

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          '현재 진행 중인 세트',
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
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {

    Size size = MediaQuery.of(context).size;
    Unit unit = units[index];
    return Column(
      children: <Widget>[
        Container(
          height: size.width * 0.2,
          width: size.width * 0.2,
          padding: EdgeInsets.symmetric(vertical: size.width * 0.02, horizontal: size.width * 0.02),
          child:  MaterialButton(
            elevation: 3.0,
            highlightElevation: 1.0,
            onPressed: () async {
              _sharedPreferences = await SharedPreferences.getInstance();
              var memberSeq = _sharedPreferences.getString('memberSeq');
              CurrentLearn currentLearn = await getCurrentLearn(memberSeq,unit.unitSeq,_bookSeq,index.toString(),_categoryName,_bookName);
              print(currentLearn);
              _categoryPressed(context, unit);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * 0.03),
            ),
            textColor: Colors.black,
            color: (_bookIndex == index) ? Colors.red.shade100: Colors.white,
            child: Opacity(
              opacity: 0.9,
              child: (_bookIndex == index) ? Image.asset('assets/images/current_fish.png') : Image.asset('assets/images/fish_image.png'),
            ),
          ),
        ),
        Text(
          unit?.unitName == null ? '' : unit.unitName,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent, fontSize: size.height * 0.015),
        ),
      ],
    );
  }

  Widget landscapeMode(context){

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          '현재 진행 중인 세트',
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
    );
  }

  Widget _buildCategoryItemL(BuildContext context, int index) {

    Size size = MediaQuery.of(context).size;
    Unit unit = units[index];
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.height * 0.02),
      child:  MaterialButton(
        elevation: 3.0,
        highlightElevation: 1.0,
        onPressed: () async {
          _sharedPreferences = await SharedPreferences.getInstance();
          var memberSeq = _sharedPreferences.getString('memberSeq');
          CurrentLearn currentLearn = await getCurrentLearn(memberSeq,unit.unitSeq,_bookSeq,index.toString(),_categoryName,_bookName);
          print(currentLearn);
          _categoryPressed(context, unit);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height * 0.03),
        ),
        textColor: Colors.black,
        color: (_bookIndex == index) ? Colors.lightBlueAccent :Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              unit?.unitName == null ? '' : unit.unitName,
              minFontSize: 8,
              maxLines: 3,
              wrapWords: false,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  _categoryPressed(BuildContext context,Unit unit) {

    if(unit.category == "listening" && unit.score == null) {
      showModalBottomSheet(
        context: context,
        builder: (sheetContext) =>
            BottomSheet(
              builder: (_) => QuizOptionsDialog(unit: unit,),
              onClosing: () {},

            ),
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => HomePage()
      ));
    }
  }
}