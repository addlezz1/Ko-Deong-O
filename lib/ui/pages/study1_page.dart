import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/models/learn.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:talkwho/ui/pages/sen1_page.dart';
import 'package:talkwho/ui/pages/study2_page.dart';
import 'package:talkwho/ui/widgets/circular_button.dart';
import 'dart:async';
import 'dart:io';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Study1Page extends StatefulWidget {
  final List<Question> questions;
  final Unit unit;
  final String type;

  const Study1Page({Key key, @required this.questions, this.unit, @required this.type}) : super(key: key);

  @override
  _Study1State createState() => _Study1State();
}

class _Study1State extends State<Study1Page> with TickerProviderStateMixin{

  bool selectedEng = false;
  bool selectedKor = false;
  bool selectedSound = false;

  List<Learn> learns = List();

  /*final TextStyle _questionStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.white
  );*/

  void _getLearn() async {
    List<Learn> learn =  await getLearn(widget.unit);
    if(this.mounted) {
      setState(() {
        learns = learn;
      });
    }
  }

  int _currentIndex = 0;
  final Map<int,dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer;
  AnimationController animationController;
  Animation degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  Animation rotationAnimation;


  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    super.initState();

    _getLearn();

    advancedPlayer  = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

    if(kIsWeb){
      return;
    }
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String type = widget.type;
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<String>(
        builder: (BuildContext context, questions) {

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.unit.unitName),
          ),
            body: Stack(
              children: <Widget>[
                new TransformerPageView(
                    loop: true,

                    viewportFraction: 0.8,
                    transformer: new PageTransformerBuilder(
                        builder: (Widget child, TransformInfo info) {

                          Question question = widget.questions[info.index];
                          //advancedPlayer.play(question.audioUrl);

                          return new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Material(
                              elevation: 8.0,
                              textStyle: new TextStyle(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10.0),
                              child: new Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  new Positioned(
                                    width: size.width * 0.3,
                                    height: size.height * 0.3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: GestureDetector(
                                        child: new Text((info.index + 1).toString() + " / " + (widget.questions.length).toString(),
                                          style: new TextStyle(
                                            fontSize: size.width * 0.045,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Positioned(
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new ParallaxContainer(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 0.0),
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: size.height * 0.02,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          position: info.position,
                                          translationFactor: 300.0,
                                        ),
                                        new ParallaxContainer(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Column(
                                                children: <Widget>[
                                                  //Padding(padding: const EdgeInsets.only(bottom: 100.0)),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        selectedKor = !selectedKor;
                                                      });
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: size.height * 0.2,
                                                        child: (type == 'kor' || type == 'sound') ? AnimatedDefaultTextStyle(
                                                          duration: const Duration(milliseconds: 300),
                                                          style: TextStyle(
                                                            color: selectedKor ? Colors.blueAccent : Colors.black.withOpacity(0.0),
                                                            fontWeight: selectedKor ? FontWeight.w400 : FontWeight.w100,
                                                          ),
                                                          child: new AutoSizeText(
                                                            question.eng,
                                                            style: TextStyle(
                                                              fontSize: 30.0,
                                                              height: 2,
                                                            ),
                                                            minFontSize: 15.0,
                                                          ),
                                                        ) : AutoSizeText(
                                                          question.eng,
                                                          style: TextStyle(
                                                            fontSize: 30.0,
                                                            color: Colors.black,
                                                            height: 2,
                                                          ),
                                                          minFontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          position: info.position,
                                          translationFactor: 300.0,
                                        ),

                                        new ParallaxContainer(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 20.0),
                                              child: Column(
                                                children: <Widget>[
                                                  //Padding(padding: const EdgeInsets.only(bottom: 100.0)),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        selectedEng = !selectedEng;
                                                      });
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        height: size.height * 0.2,
                                                        child: (type == 'eng' || type == 'sound') ? AnimatedDefaultTextStyle(
                                                          duration: const Duration(milliseconds: 300),
                                                          style: TextStyle(
                                                            color: selectedEng ? Colors.blueAccent : Colors.black.withOpacity(0.0),
                                                            fontWeight: selectedEng ? FontWeight.w400 : FontWeight.w100,
                                                          ),
                                                          child: new AutoSizeText(
                                                            question.kor,
                                                            style: TextStyle(
                                                              fontSize: 30.0,
                                                              height: 2,
                                                            ),
                                                            minFontSize: 15.0,
                                                          ),
                                                        ) : AutoSizeText(
                                                          question.kor,
                                                          style: TextStyle(
                                                            fontSize: 30.0,
                                                            color: Colors.black,
                                                            height: 2,
                                                          ),
                                                          minFontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          position: info.position,
                                          translationFactor: 300.0,
                                        ),
                                      ],
                                    ),
                                    left: size.width * 0.02,
                                    right: size.width * 0.02,
                                    top: size.height * 0.1,
                                  ),
                                  Positioned(
                                    left: size.width * 0.28,
                                    top: size.height * 0.64,
                                    child: Row(
                                      children: <Widget>[
                                        new ParallaxContainer(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Column(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: (type == 'eng') ? IconButton(
                                                      icon: Icon(
                                                        Icons.done,
                                                        size: size.width * 0.08,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedEng = !selectedEng;
                                                        });
                                                      },
                                                      color: Color(0xff616161),
                                                    ) : (type == 'kor') ? IconButton(
                                                      icon: Icon(
                                                        Icons.done,
                                                        size: size.width * 0.08,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedKor = !selectedKor;
                                                        });
                                                      },
                                                      color: Color(0xff616161),
                                                    ) : IconButton(
                                                      icon: Icon(
                                                        Icons.done,
                                                        size: size.width * 0.08,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedEng = !selectedEng;
                                                          selectedKor = !selectedKor;
                                                        });
                                                      },
                                                      color: Color(0xff616161),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          position: info.position,
                                          translationFactor: 300.0,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.15,
                                        ),
                                        new ParallaxContainer(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Column(
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.volume_up,
                                                      size: 30.0,
                                                    ),
                                                    onPressed: () async {
                                                      print(question.audioUrl);
                                                      advancedPlayer.play(question.audioUrl);
                                                    },
                                                    color: Color(0xff616161),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          position: info.position,
                                          translationFactor: 300.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    itemCount: widget.questions.length),
                /*Positioned(
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
                            getRadiansFromDegree(180), degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                            ..scale(degOneTranslationAnimation.value),
                          alignment: Alignment.center,
                          child: CircularButton(
                            color: Colors.blue,
                            width: size.width * 0.14,
                            height: size.height * 0.1,
                            icon: Icon(
                              Icons.change_history,
                              color: Colors.white,
                            ),
                            onClick: () async{
                              List<Question> questions =  await getQuestions(widget.unit, learns[1].type, learns[1].code);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => Study2Page(questions: questions, unit: widget.unit)
                                  builder: (_) => Study2Page(questions: questions, unit: widget.unit)
                              ));
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("code", learns[1].code.toString());
                              prefs.setString("unit", widget.unit.unitSeq);
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset:
                        Offset.fromDirection(
                            getRadiansFromDegree(225), degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                            ..scale(degOneTranslationAnimation.value),
                          alignment: Alignment.center,
                          child: CircularButton(
                            color: Colors.black,
                            width: size.width * 0.14,
                            height: size.height * 0.1,
                            icon: Icon(
                              Icons.hearing,
                              color: Colors.white,
                            ),
                            onClick: () async{
                              List<Question> questions =  await getQuestions(widget.unit, learns[2].type, learns[2].code);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => Study2Page(questions: questions, unit: widget.unit)
                              ));
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("code", learns[2].code.toString());
                              prefs.setString("unit", widget.unit.unitSeq);
                            },
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset:
                        Offset.fromDirection(
                            getRadiansFromDegree(270), degOneTranslationAnimation.value * 100),
                        child: Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                            ..scale(degOneTranslationAnimation.value),
                          alignment: Alignment.center,
                          child: CircularButton(
                            color: Colors.orangeAccent,
                            width: size.width * 0.14,
                            height: size.height * 0.1,
                            icon: Icon(
                              Icons.library_books,
                              color: Colors.white,
                            ),
                            onClick: () async{
                              List<Question> questions =  await getQuestions(widget.unit, learns[3].type, learns[3].code);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => Sen1Page(questions: questions, unit: widget.unit)
                              ));
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("code", learns[3].code.toString());
                              prefs.setString("unit", widget.unit.unitSeq);
                            },
                          ),
                        ),
                      ),
                      Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.red,
                          width: size.width * 0.16,
                          height: size.height * 0.1,
                          icon: Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          onClick: () {
                            if(animationController.isCompleted){
                              animationController.reverse();
                            } else {
                              animationController.forward();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          );
        });
  }
}