import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/models/learn.dart';
import 'package:talkwho/models/question.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/study1_page.dart';
import 'package:talkwho/ui/pages/study2_page.dart';
import 'package:talkwho/ui/widgets/circular_button.dart';
import 'package:talkwho/ui/widgets/gradient_icon.dart';

class VocaListPage extends StatefulWidget {
  final List<Question> questions;
  final Unit unit;

  const VocaListPage({Key key, @required this.questions, this.unit}) : super(key: key);

  @override
  _VocaListPageState createState() => _VocaListPageState();
}

class _VocaListPageState extends State<VocaListPage> with TickerProviderStateMixin{

  AnimationController animationController;
  Animation degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  Animation rotationAnimation;

  List<Learn> learns = List();

  bool _isClicked = false;
  bool _isSaved;

  String _memberSeq = '';

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  void _getLearn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String memberSeq = prefs.getString('memberSeq');
    List<Learn> learn =  await getLearn(widget.unit);
    if(this.mounted) {
      setState(() {
        learns = learn;
        _memberSeq = memberSeq;
      });
    }
  }

  @override
  void initState(){
    _getLearn();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0,end: 1.2), weight: 75.0),
      TweenSequenceItem(tween: Tween(begin: 1.2,end: 1.0), weight: 25.0),
    ])
        .animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0,end: 1.4), weight: 55.0),
      TweenSequenceItem(tween: Tween(begin: 1.4,end: 1.0), weight: 45.0)
    ])
        .animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0,end: 1.75), weight: 35.0),
      TweenSequenceItem(tween: Tween(begin: 1.75,end: 1.0), weight: 65.0)
    ])
        .animate(animationController);
    rotationAnimation = Tween(begin: 180.0, end: 0.0)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unit.unitName),
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
              tileMode: TileMode.clamp
          ),
        ),
        child: Stack(
          children: <Widget>[
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.questions.length,
              itemBuilder: _buildItem,
            ),

            Positioned(
              right: size.width * 0.05,
              bottom: size.height * 0.03,
              child: Stack(
                //시작점을 잡아준다 -> ignorePointer 의 기준점 설정 가능
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  //translate 될 때 변화를 무시해줄 수 있는 포인터 AbsorbPointer 도 있음
                  IgnorePointer(
                    child: Container(
                      //padding: const EdgeInsets.only(left: 100.0),
                      color: Colors.black.withOpacity(0.0),
                      height: size.height * 0.24,
                      width: size.width * 0.38,
                    ),
                  ),
                  Transform.translate(
                    offset:
                    Offset.fromDirection(
                        getRadiansFromDegree(180), degOneTranslationAnimation.value * size.width * 0.23),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                          borderRadius: BorderRadius.circular(size.width * 0.12),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: size.width * 0.10,
                                  height: size.width * 0.10,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(size.width * 0.8),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Opacity(
                                      opacity: 0.5,
                                      child: GradientText("한",
                                          gradient: LinearGradient(
                                              colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                          style: TextStyle(fontSize: size.width * 0.055, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.03,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: size.width * 0.03,
                                    ),
                                    GradientIcon(
                                      icon: FontAwesomeIcons.font,
                                      size: size.width * 0.07,
                                      gradient: new LinearGradient(
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlueAccent
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            MaterialButton(
                              height: size.width * 0.14,
                              elevation: 1.0,
                              highlightElevation: 1.0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () async{
                                List<Question> questions =  await getVocaQuestions(widget.unit, learns[0].type, learns[0].code, _memberSeq);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'eng',)
                                ));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset:
                    Offset.fromDirection(
                        getRadiansFromDegree(210), degOneTranslationAnimation.value * size.width * 0.23),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                          borderRadius: BorderRadius.circular(size.width * 0.12),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: size.width * 0.10,
                                  height: size.width * 0.10,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(size.width * 0.8),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.015,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Opacity(
                                      opacity: 0.5,
                                      child: GradientIcon(
                                        icon: FontAwesomeIcons.font,
                                        size: size.width * 0.055,
                                        gradient: new LinearGradient(
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlueAccent
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: size.width * 0.035,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: size.width * 0.015,
                                    ),
                                    GradientText("한",
                                        gradient: LinearGradient(
                                            colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                        style: TextStyle(fontSize: size.width * 0.068, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            MaterialButton(
                              height: size.width * 0.14,
                              elevation: 1.0,
                              highlightElevation: 1.0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () async{
                                List<Question> questions =  await getVocaQuestions(widget.unit, learns[0].type, learns[0].code, _memberSeq);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'kor',)
                                ));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset:
                    Offset.fromDirection(
                        getRadiansFromDegree(240), degOneTranslationAnimation.value * size.width * 0.23),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                          borderRadius: BorderRadius.circular(size.width * 0.12),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: size.width * 0.10,
                                  height: size.width * 0.10,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(size.width * 0.8),
                                  ),
                                ),
                              ],
                            ),
                            GradientIcon(
                              icon: FontAwesomeIcons.headphones,
                              size: size.width * 0.08,
                              gradient: new LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent
                                ],
                              ),
                            ),
                            MaterialButton(
                              height: size.width * 0.14,
                              elevation: 1.0,
                              highlightElevation: 1.0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () async{
                                List<Question> questions =  await getVocaQuestions(widget.unit, learns[0].type, learns[0].code, _memberSeq);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'sound',)
                                ));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset:
                    Offset.fromDirection(
                        getRadiansFromDegree(270), degOneTranslationAnimation.value * size.width * 0.23),
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                          borderRadius: BorderRadius.circular(size.width * 0.12),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: size.width * 0.10,
                                  height: size.width * 0.10,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(size.width * 0.8),
                                  ),
                                ),
                              ],
                            ),
                            GradientIcon(
                              icon: FontAwesomeIcons.question,
                              size: size.width * 0.08,
                              gradient: new LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent
                                ],
                              ),
                            ),
                            MaterialButton(
                              height: size.width * 0.14,
                              elevation: 1.0,
                              highlightElevation: 1.0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () async{
                                List<Question> questions =  await getVocaQuestions(widget.unit, learns[1].type, learns[1].code, _memberSeq);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => Study2Page(questions: questions, unit: widget.unit)
                                ));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: (_isClicked == false)? 0.5 : 1.0,
                    child: Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.16,
                        height: size.width * 0.16,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                          borderRadius: BorderRadius.circular(size.width * 0.1),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: size.width * 0.05,
                                  height: size.width * 0.05,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(size.width * 0.8),
                                  ),
                                ),
                              ],
                            ),
                            MaterialButton(
                              height: size.width * 0.14,
                              elevation: 1.0,
                              highlightElevation: 1.0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                if(animationController.isCompleted){
                                  animationController.reverse();
                                } else {
                                  animationController.forward();
                                }
                                (_isClicked == false)?_isClicked = true : _isClicked = false;
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {

    Size size = MediaQuery.of(context).size;

    Question question = widget.questions[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: size.width * 0.34,
              child: AutoSizeText(HtmlUnescape().convert(question.correctAnswer),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
              minFontSize: 8.0,
              ),
            ),
            SizedBox(width: size.width * 0.04),
            SizedBox(
              width: size.width * 0.34,
              child: AutoSizeText(HtmlUnescape().convert(question.question),
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                ),
                minFontSize: 8.0,
                maxLines: 1,
              ),
            ),
            SizedBox(width: size.width * 0.03),
            new GestureDetector(
              onTap: () async{
                setState(() {
                  question.isSaved =
                  !question.isSaved;
                });
                (question.isSaved == true)? _isSaved = await getSavedWord(_memberSeq, widget.unit.unitSeq, question.vocaSeq, question.correctAnswer, question.question):
                    _isSaved = await getDeleteWord(_memberSeq, question.vocaSeq);
              },
              child: new AnimatedOpacity(
                opacity: (question.isSaved == false)?0.6:1.0,
                duration: Duration(milliseconds: 500),
                child: new GradientIcon(
                  icon: (question.isSaved == false)?FontAwesomeIcons.star : FontAwesomeIcons.solidStar,
                  size: size.width * 0.06,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.yellow,
                      Colors.orange
                    ],
                  ),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            /*IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: GradientIcon(
                icon: (_isSaved == false)?FontAwesomeIcons.star : FontAwesomeIcons.solidStar,
                size: size.width * 0.06,
                gradient: new LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.orange
                  ],
                ),
              ),
              onPressed: (){
                (_isSaved == false)?_isSaved = true : _isSaved = false;
              },
            )*/
            ),
          ],
        ),
      ),
    );
  }
}