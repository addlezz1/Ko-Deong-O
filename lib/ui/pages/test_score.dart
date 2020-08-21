import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:talkwho/models/testScore.dart';
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

class TestScorePage extends StatefulWidget {
  final Book book;
  const TestScorePage({Key key, this.book}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TestScorePage> with TickerProviderStateMixin {

  List<TestScore> testScores = List(999);

  String _memberSeq = '';
  String _bookSeq = '';
  int _bookIndex = 0;
  bool selected = false;

  SharedPreferences _sharedPreferences;

  void _getTestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String memberSeq = prefs.getString('memberSeq');
    _memberSeq = memberSeq;
    List<TestScore> testScore = await getTestScore(_memberSeq);
    //print(currentUnit.unitSeq);
    if(this.mounted) {
      setState(() {
        testScores = testScore;
      });
    }
  }

  void initState(){
    super.initState();
    _getTestScore();
  }

  @override
  Widget build(BuildContext context){

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          '점수',
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
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: testScores.length,
              itemBuilder: (BuildContext context, int index){
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 44.0,
                    child: FadeInAnimation(
                      child: _buildCategoryItem(context, index),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, index) {

    Size size = MediaQuery.of(context).size;

    TestScore testScore = testScores[index];
    String aIndex = ':';
    int questionIndex = testScore?.result?.indexOf(aIndex);

    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: (_bookIndex == index && selected) ? size.height * 0.25 : size.height * 0.1,
        decoration: (_bookIndex == index) ? BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
          borderRadius: BorderRadius.circular(size.width * 0.1),
        ) : BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Colors.green,
                Colors.greenAccent
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
          borderRadius: BorderRadius.circular(size.width * 0.1),
        ),
        child: new MaterialButton(
          elevation: 3.0,
          highlightElevation: 1.0,
          onPressed: () {
            if(this.mounted){
              setState(() {
                selected = !selected;
                _bookIndex = index;
              });
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                testScore?.unitName == null ? '' : '<' + testScore.registDate.substring(5,10) + '> ' + testScore.unitName,
                minFontSize: 14.0,
                textAlign: TextAlign.center,
                maxLines: 2,
                wrapWords: false,
              ),
              (_bookIndex == index && selected) ? AutoSizeText(
                testScore?.unitName == null ? '' : '점수: ' + testScore.score + '(' + testScore.result.substring(0,questionIndex) + ')',
                minFontSize: 18.0,
                textAlign: TextAlign.left,
                maxLines: 1,
                wrapWords: false,
              ) : SizedBox(),
              (_bookIndex == index && selected) ? SizedBox(
                height: size.height * 0.01,
              ) : SizedBox(),
              (_bookIndex == index && selected) ?
              testScore?.unitName == null ? '' : Text('틀린 단어:', style: TextStyle(fontSize: 18.0),) :
              SizedBox(),
              (_bookIndex == index && selected) ? AutoSizeText(
                testScore?.unitName == null ? '' : testScore.result.substring(questionIndex+1,testScore.result.length-1),
                minFontSize: 14.0,
                textAlign: TextAlign.left,
                maxLines: 3,
                wrapWords: false,
              ): SizedBox(),
            ],
          ),
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
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => HomePage()
      ));
    }
  }
}