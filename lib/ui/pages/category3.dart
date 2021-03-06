import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:talkwho/models/category.dart';
import 'package:talkwho/models/question.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/ui/pages/category2.dart';
import 'package:talkwho/ui/pages/home.dart';
import 'package:talkwho/ui/pages/main.dart';
import 'package:talkwho/ui/pages/text_list.dart';
import 'package:talkwho/ui/pages/voca_list.dart';
import 'package:talkwho/ui/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/models/book.dart';
import 'learn_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/models/currentLearn.dart';

class Category3Page extends StatefulWidget {
  final Book book;
  final Category category;
  final String bookValue;
  const Category3Page({Key key, this.book, this.category, this.bookValue}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Category3Page> {

  List<Unit> units = List(999);

  SharedPreferences _sharedPreferences;
  String _memberSeq = '';

  void _getUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberSeq = prefs.getString('memberSeq');
    List<Unit> unit =  await getUnit(widget.book.bookSeq);
    if(this.mounted) {
      setState(() {
        units = unit;
        _memberSeq = memberSeq;
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
            builder: (_) => Category2Page(category: widget.category, bookValue: widget.bookValue,)
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
                  builder: (_) => Category2Page(category: widget.category,bookValue: widget.bookValue,)
              ));
            },
          ),
          title: AutoSizeText(
            widget.book.bookName +'의 세트를 지정해주세요',
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
            builder: (_) => Category2Page(category: widget.category, bookValue: widget.bookValue,)
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
                  builder: (_) => Category2Page(category: widget.category,bookValue: widget.bookValue,)
              ));
            },
          ),
          title: AutoSizeText(
            widget.book.bookName +'의 세트를 지정해주세요',
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
                padding: EdgeInsets.all(size.width * 0.01),
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
    Unit unit = units[index];
    return Column(
      children: <Widget>[
        Container(
          height: size.width * 0.2,
          width: size.width * 0.2,
          padding: EdgeInsets.symmetric(vertical: size.width * 0.02, horizontal: size.width * 0.02),
          child: new MaterialButton(
            elevation: 3.0,
            highlightElevation: 1.0,
            onPressed: () async {
              _sharedPreferences = await SharedPreferences.getInstance();
              var memberSeq = _sharedPreferences.getString('memberSeq');
              CurrentLearn currentLearn = await getCurrentLearn(memberSeq,unit.unitSeq,widget.book.bookSeq,index.toString(),widget.category.title,widget.book.bookName);
              print(currentLearn);
              if(widget.book.bookName == 'Reading'){
                List<Question> questions =  await getQuestions(unit, 'text', '201');
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => TextListPage(questions: questions, unit: unit,type: 'reading',)
                ));
              } else if(widget.book.bookName == 'Listening'){
                List<Question> questions =  await getQuestions(unit, 'text', '202');
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => TextListPage(questions: questions, unit: unit,type: 'listening',)
                ));
              } else if(widget.book.bookName.substring(0,4) == 'Voca'){
                List<Question> questions =  await getVocaQuestions(unit, 'text', '101', _memberSeq);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => VocaListPage(questions: questions, unit: unit)
                ));
              }
            },
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
          unit?.unitName == null ? '' : unit.unitName,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent, fontSize: size.height * 0.015),
        ),
      ],
    );
  }

  Widget _buildCategoryItemL(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    Unit unit = units[index];
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.2,
          width: size.height * 0.2,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.height * 0.02),
          child: new MaterialButton(
            elevation: 3.0,
            highlightElevation: 1.0,
            onPressed: () async {
              _sharedPreferences = await SharedPreferences.getInstance();
              var memberSeq = _sharedPreferences.getString('memberSeq');
              CurrentLearn currentLearn = await getCurrentLearn(memberSeq,unit.unitSeq,widget.book.bookSeq,index.toString(),widget.category.title,widget.book.bookName);
              print(currentLearn);
              if(widget.book.bookName == 'Reading'){
                List<Question> questions =  await getQuestions(unit, 'text', '201');
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => TextListPage(questions: questions, unit: unit,type: 'reading',)
                ));
              } else if(widget.book.bookName == 'Listening'){
                List<Question> questions =  await getQuestions(unit, 'text', '202');
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => TextListPage(questions: questions, unit: unit,type: 'listening',)
                ));
              } else if(widget.book.bookName.substring(0,4) == 'Voca'){
                List<Question> questions =  await getVocaQuestions(unit, 'text', '101', _memberSeq);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => VocaListPage(questions: questions, unit: unit)
                ));
              }
            },
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
          unit?.unitName == null ? '' : unit.unitName,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent, fontSize: size.width * 0.015),
        ),
      ],
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

    }
  }
}