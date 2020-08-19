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
      body: SafeArea(
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
    );
  }

  Widget _buildCategoryItem(BuildContext context, index) {

    Size size = MediaQuery.of(context).size;

    TestScore testScore = testScores[index];
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: (_bookIndex == index && selected) ? size.height * 0.2 : size.height * 0.1,
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
          color: (_bookIndex == index) ? Colors.greenAccent : Colors.white,
          textColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                testScore?.unitName == null ? '' : testScore.unitName + ' ' + testScore.registDate.substring(0,10),
                minFontSize: 8.0,
                textAlign: TextAlign.center,
                maxLines: 1,
                wrapWords: false,
              ),
              (_bookIndex == index && selected) ? AutoSizeText(
                testScore?.unitName == null ? '' : testScore.score,
                minFontSize: 8.0,
                textAlign: TextAlign.center,
                maxLines: 1,
                wrapWords: false,
              ) : SizedBox(),
              (_bookIndex == index && selected) ? AutoSizeText(
                testScore?.unitName == null ? '' : testScore.result,
                minFontSize: 8.0,
                textAlign: TextAlign.center,
                maxLines: 2,
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