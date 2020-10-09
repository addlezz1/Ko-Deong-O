import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/models/currentLearn.dart';
import 'package:talkwho/models/learn.dart';
import 'package:talkwho/models/question.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/home.dart';
import 'package:talkwho/ui/pages/quiz_page.dart';
import 'package:talkwho/ui/pages/study1_page.dart';
import 'package:talkwho/ui/pages/voca_list.dart';
import 'package:talkwho/ui/widgets/circular_button.dart';
import 'package:talkwho/ui/widgets/gradient_icon.dart';

class TextListPage extends StatefulWidget {
  final List<Question> questions;
  final Unit unit;
  final String type;

  const TextListPage({Key key, @required this.questions, this.unit, @required this.type}) : super(key: key);

  @override
  _TextListPageState createState() => _TextListPageState();
}

class _TextListPageState extends State<TextListPage> with TickerProviderStateMixin{

  AnimationController animationController;
  Animation degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  Animation rotationAnimation;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  String _memberSeq = '';
  String _bookSeq = '';
  String _categoryName = '';
  String _bookName = '';
  int _bookIndex = 0;
  int _unitSort = 0;
  String soundClick = '0';
  bool onlyEng = false;

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  List<Learn> learns = List();
  List<Unit> units = List<Unit>(999);

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  void _getLearn() async {
    List<Learn> learn =  await getLearn(widget.unit);
    if(this.mounted) {
      setState(() {
        learns = learn;
      });
    }
  }

  void _getCurrentUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String memberSeq = prefs.getString('memberSeq');
    _memberSeq = memberSeq;
    CurrentLearn currentUnit = await getCurrentUnit(_memberSeq);
    _bookSeq = currentUnit.bookSeq;
    _categoryName = currentUnit.categoryName;
    _bookName = currentUnit.bookName;
    //_title = currentUnit.title;

    if(currentUnit.bookIndex != null) {
      _bookIndex = int.parse(currentUnit.bookIndex);
      //print(_bookSeq);
    }

    if(currentUnit.unitSort != null) {
      _unitSort = int.parse(currentUnit.unitSort);
    }
    units = await getUnit(_bookSeq);
    if(this.mounted) {
      setState(() {
      });
    }
    //print(units[_bookIndex].unitName);
    //print(units[_bookIndex].unitSeq);
  }

  @override
  void initState(){
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

    _getLearn();
    _getCurrentUnit();
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
    String sentenceEng = '';
    String sentenceKor = '';
    Text textSentence;
    List<Audio> playList = new List<Audio>();
    for (var i = 0; i < widget.questions.length; i++) {
      (widget.questions[i].correctAnswer.substring(0,2).trim() == 'W:')? playList.add(Audio.network(widget.questions[i].mediaUrl)): playList.add(Audio.network(widget.questions[i].audioUrl));
    }

    if(widget.type == 'reading') {
      for (var i = 0; i < widget.questions.length; i++) {
        sentenceEng += ' ' + widget.questions[i].correctAnswer.toString();
      }

      for (var i = 0; i < widget.questions.length; i++) {
        sentenceKor += ' ' + widget.questions[i].question.toString();
      }
    } else if(widget.type == 'listening') {
      /*setState(() {
        textSentence = RichText(
          text: TextSpan(
              text: widget.questions[0].correctAnswer.substring(0,2).trim().toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(text: widget.questions[0].correctAnswer.substring(2).trim().toString(), style: TextStyle(fontWeight: FontWeight.normal),)
              ]
          ),
        );
      });*/
      //textSentence = Text(widget.questions[0].correctAnswer.substring(0,2).trim());
      sentenceEng += widget.questions[0].correctAnswer.toString();
      for (var i = 1; i < widget.questions.length; i++) {
        sentenceEng += '\n' + widget.questions[i].correctAnswer.toString();
      }
      sentenceKor += widget.questions[0].question.toString();
      for (var i = 1; i < widget.questions.length; i++) {
        sentenceKor += '\n' + widget.questions[i].question.toString();
      }
    }

    return WillPopScope(
      onWillPop: () async{
        assetsAudioPlayer.stop();
        setState(() {
          soundClick = '0';
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => HomePage()
        ),);
        return false;
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.home, color: Colors.white,
            ),
            onPressed: (){
              assetsAudioPlayer.stop();
              setState(() {
                soundClick = '0';
              });
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => HomePage()
              ));
            },
          ),
          title: AutoSizeText(
            widget.unit.unitName,
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
                tileMode: TileMode.clamp
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AnimatedSize(
                    vsync: this,
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 200),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: size.width * 0.9,
                              height: (onlyEng == false ) ? size.height * 0.33 : size.height * 0.7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: (widget.type == 'reading') ?Text(HtmlUnescape().convert(sentenceEng),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.height * 0.02,
                                    height: 2,
                                  ),
                                ) : Text(HtmlUnescape().convert(sentenceEng),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.height * 0.02,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedSize(
                    vsync: this,
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 200),
                      child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: size.width * 0.9,
                              height: (onlyEng == false ) ? size.height * 0.33 : size.height * 0,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(HtmlUnescape().convert(sentenceKor),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.height * 0.02,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: size.width * 0.43,
                bottom: (onlyEng == false)? size.height * 0.45 : size.height * 0.1,
                child: Opacity(
                  opacity: 1,
                  child: CircularButton(
                    color: Colors.transparent,
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    icon: (onlyEng == false)? Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: size.width < 700 ? size.width * 0.08 : size.width * 0.06,
                    ) : Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black54,
                      size: size.width < 700 ? size.width * 0.08 : size.width * 0.06,
                    ) ,
                    onClick: (){
                      setState(() {
                        onlyEng = !onlyEng;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                left: size.width * 0.02,
                bottom: size.width < 700 ? size.height * 0.455 : size.height * 0.485,
                child: Opacity(
                  opacity: 0.3,
                  child: CircularButton(
                    color: Colors.blue,
                    width: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                    height: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: size.width * 0.05,
                    ),
                    onClick: (_bookIndex == 0)? _isFirstUnit
                        : (widget.type == 'reading')? () async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex-1], learns[4].type, learns[4].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex-1].unitSeq,_bookSeq,(_bookIndex-1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex-1], type: 'reading',)
                      ));
                    } :() async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex-1], learns[5].type, learns[5].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex-1].unitSeq,_bookSeq,(_bookIndex-1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex-1], type: 'listening',)
                      ));
                    },
                  ),
                ),
              ),
              Positioned(
                right: size.width * 0.02,
                bottom: size.width < 700 ? size.height * 0.455 : size.height * 0.485,
                child: Opacity(
                  opacity: 0.3,
                  child: CircularButton(
                    color: Colors.blue,
                    width: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                    height: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: size.width * 0.05,
                    ),
                    onClick: (_bookIndex == _unitSort-1)? _isLastUnit
                        :(widget.type == 'reading')? () async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex+1], learns[4].type, learns[4].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex+1].unitSeq,_bookSeq,(_bookIndex+1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex+1], type: 'reading',)
                      ));
                    } :() async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex+1], learns[5].type, learns[5].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex+1].unitSeq,_bookSeq,(_bookIndex+1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex+1], type: 'listening',)
                      ));
                    },
                  ),
                ),
              ),
              Positioned(
                left: size.width < 700 ? size.width * 0.368 : size.width * 0.383,
                bottom: size.height * 0.02,
                child: Material(
                  elevation: 3,
                  borderRadius: new BorderRadius.circular(size.width * 0.1),
                  child: Row(
                    children: <Widget>[
                      (soundClick == '0') ? IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.playCircle,
                          size: size.width < 700 ? size.width * 0.1 : size.width * 0.085,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () async {
                          assetsAudioPlayer.open(
                            Playlist(
                                audios: playList
                            ),
                            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug
                          );
                          setState(() {
                            soundClick = '1';
                          });
                          assetsAudioPlayer.playlistFinished.listen((data) {
                            if(data == true){
                              setState(() {
                                soundClick = '0';
                              });
                            }
                          });
                        },
                        iconSize: size.width < 700 ? size.width * 0.11 : size.width * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ) : (soundClick == '1') ? IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.pauseCircle,
                          size: size.width < 700 ? size.width * 0.1 : size.width * 0.085,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () async{
                          assetsAudioPlayer.pause();
                          setState(() {
                            soundClick = '2';
                          });
                        },
                        iconSize: size.width < 700 ? size.width * 0.11 : size.width * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ) : IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.playCircle,
                          size: size.width < 700 ? size.width * 0.1 : size.width * 0.085,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () async{
                          assetsAudioPlayer.play();
                          setState(() {
                            soundClick = '1';
                          });
                        },
                        iconSize: size.width < 700 ? size.width * 0.11 : size.width * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.stopCircle,
                          size: size.width < 700 ? size.width * 0.1 : size.width * 0.085,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () {
                          assetsAudioPlayer.stop();
                          setState(() {
                            soundClick = '0';
                          });
                        },
                        iconSize: size.width < 700 ? size.width * 0.11 : size.width * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
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
                    (widget.type == 'listening') ?
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(170), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
                          height: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
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
                                    width: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    height: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
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
                                    width: size.width < 700 ? size.width * 0.02 : size.width * 0.015,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: 0.5,
                                        child: GradientText("한",
                                            gradient: LinearGradient(
                                                colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                            style: TextStyle(fontSize: size.width < 700 ? size.width * 0.055 : size.width * 0.045, fontWeight: FontWeight.bold),
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
                                        size: size.width < 700 ? size.width * 0.07 : size.width * 0.05,
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
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (widget.type == 'reading')? () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, learns[4].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'eng', textVoca: 'text')
                                  ));
                                } : () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[5].type, learns[5].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'eng', textVoca: 'text')
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
                    ) :
                    SizedBox(
                      width: size.width * 0,
                      height: size.width * 0,
                    ),
                    (widget.type == 'listening') ?
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(200), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
                          height: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
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
                                    width: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    height: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
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
                                          size: size.width < 700 ? size.width * 0.055 : size.width * 0.045,
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
                                          style: TextStyle(fontSize: size.width < 700 ? size.width * 0.068 : size.width * 0.053, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (widget.type == 'reading')? () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, learns[4].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'kor', textVoca: 'text')
                                  ));
                                } : () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[5].type, learns[5].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'kor', textVoca: 'text')
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
                    ) :
                    SizedBox(
                      width: size.width * 0,
                      height: size.width * 0,
                    ),
                    (widget.type == 'listening') ?
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(230), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
                          height: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
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
                                    width: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    height: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientIcon(
                                icon: FontAwesomeIcons.headphones,
                                size: size.width < 700 ? size.width * 0.08 : size.width * 0.06,
                                gradient: new LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ],
                                ),
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (widget.type == 'reading')? () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, learns[4].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'sound', textVoca: 'text')
                                  ));
                                } : () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[5].type, learns[5].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'sound', textVoca: 'text')
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
                    ) :
                    SizedBox(
                      width: size.width * 0,
                      height: size.width * 0,
                    ),
                    Transform.translate(
                      offset:
                      (widget.type == 'reading')?
                      Offset.fromDirection(
                          getRadiansFromDegree(220), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2) :
                      Offset.fromDirection(
                          getRadiansFromDegree(260), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
                          height: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
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
                                    width: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    height: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientIcon(
                                icon: FontAwesomeIcons.question,
                                size: size.width < 700 ? size.width * 0.08 : size.width * 0.06,
                                gradient: new LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ],
                                ),
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, '207');
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => (widget.type == 'listening')? QuizPage(questions: questions, playlist: playList, unit: widget.unit, sentence: sentenceEng, code: '207', type: 'listening') :
                                                                                    QuizPage(questions: questions, unit: widget.unit, sentence: sentenceEng, code: '207', type: 'reading')
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
                      (widget.type == 'reading')?
                      Offset.fromDirection(
                          getRadiansFromDegree(250), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2):
                      Offset.fromDirection(
                          getRadiansFromDegree(290), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
                          height: size.width < 700 ? size.width * 0.12 : size.width * 0.1,
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
                                    width: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    height: size.width < 700 ? size.width * 0.1 : size.width * 0.08,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("V",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.width * 0.09 : size.width * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  try{
                                    List<Question> questions =  await getVocaQuestions(widget.unit, 'text', '101', _memberSeq);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => VocaListPage(questions: questions, unit: widget.unit)
                                    ));
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("지문에 해당하는 단어가 없습니다."), duration: Duration(milliseconds: 800),
                                    ));
                                  }
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
                    Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width < 700 ? size.width * 0.16 : size.width * 0.13,
                        height: size.width < 700 ? size.width * 0.16 : size.width * 0.13,
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
                                  width: size.width < 700 ? size.width * 0.05 : size.width * 0.04,
                                  height: size.width < 700 ? size.width * 0.05 : size.width * 0.04,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(size.width * 0.8),
                                  ),
                                ),
                              ],
                            ),
                            MaterialButton(
                              height: size.width < 700 ? size.width * 0.14 : size.width * 0.12,
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
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget landscapeMode(context){

    Size size = MediaQuery.of(context).size;
    String sentenceEng = '';
    String sentenceKor = '';
    Text textSentence;
    List<Audio> playList = new List<Audio>();
    for (var i = 0; i < widget.questions.length; i++) {
      (widget.questions[i].correctAnswer.substring(0,2).trim() == 'W:')? playList.add(Audio.network(widget.questions[i].mediaUrl)): playList.add(Audio.network(widget.questions[i].audioUrl));
    }

    if(widget.type == 'reading') {
      for (var i = 0; i < widget.questions.length; i++) {
        sentenceEng += ' ' + widget.questions[i].correctAnswer.toString();
      }

      for (var i = 0; i < widget.questions.length; i++) {
        sentenceKor += ' ' + widget.questions[i].question.toString();
      }
    } else if(widget.type == 'listening') {
      /*setState(() {
        textSentence = RichText(
          text: TextSpan(
              text: widget.questions[0].correctAnswer.substring(0,2).trim().toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(text: widget.questions[0].correctAnswer.substring(2).trim().toString(), style: TextStyle(fontWeight: FontWeight.normal),)
              ]
          ),
        );
      });*/
      //textSentence = Text(widget.questions[0].correctAnswer.substring(0,2).trim());
      sentenceEng += widget.questions[0].correctAnswer.toString();
      for (var i = 1; i < widget.questions.length; i++) {
        sentenceEng += '\n' + widget.questions[i].correctAnswer.toString();
      }
      sentenceKor += widget.questions[0].question.toString();
      for (var i = 1; i < widget.questions.length; i++) {
        sentenceKor += '\n' + widget.questions[i].question.toString();
      }
    }

    return WillPopScope(
      onWillPop: () async{
        assetsAudioPlayer.stop();
        setState(() {
          soundClick = '0';
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => HomePage()
        ),);
        return false;
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.home, color: Colors.white, size: size.height * 0.04,
            ),
            onPressed: (){
              assetsAudioPlayer.stop();
              setState(() {
                soundClick = '0';
              });
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => HomePage()
              ));
            },
          ),
          title: AutoSizeText(
            widget.unit.unitName,
            minFontSize: 13.0,
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
                tileMode: TileMode.clamp
            ),
          ),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  AnimatedSize(
                    vsync: this,
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 200),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(size.height * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: size.width * 0.425,
                              height: (onlyEng == false ) ? size.height * 0.68 : size.height * 0.68,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: (widget.type == 'reading') ?Text(HtmlUnescape().convert(sentenceEng),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.width * 0.02,
                                    height: 2,
                                  ),
                                ) : Text(HtmlUnescape().convert(sentenceEng),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.width * 0.02,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedSize(
                    vsync: this,
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 200),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(size.height * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: size.width * 0.425,
                              height: (onlyEng == false ) ? size.height * 0.68 : size.height * 0.68,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(HtmlUnescape().convert(sentenceKor),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: (onlyEng) ? Colors.transparent : Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.width * 0.02,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: size.width * 0.91,
                bottom: size.height * 0.79,
                child: Opacity(
                  opacity: 1,
                  child: CircularButton(
                    color: Colors.transparent,
                    width: size.height * 0.15,
                    height: size.height * 0.15,
                    icon: Icon(
                      onlyEng
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                      size: size.height * 0.04,
                      color: Colors.blueAccent,
                    ) ,
                    onClick: (){
                      setState(() {
                        onlyEng = !onlyEng;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                left: size.width * 0.02,
                bottom: size.height * 0.43,
                child: Opacity(
                  opacity: 0.3,
                  child: CircularButton(
                    color: Colors.blue,
                    width: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                    height: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: size.height * 0.05,
                    ),
                    onClick: (_bookIndex == 0)? _isFirstUnit
                        : (widget.type == 'reading')? () async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex-1], learns[4].type, learns[4].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex-1].unitSeq,_bookSeq,(_bookIndex-1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex-1], type: 'reading',)
                      ));
                    } :() async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex-1], learns[5].type, learns[5].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex-1].unitSeq,_bookSeq,(_bookIndex-1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex-1], type: 'listening',)
                      ));
                    },
                  ),
                ),
              ),
              Positioned(
                right: size.width * 0.02,
                bottom: size.height * 0.43,
                child: Opacity(
                  opacity: 0.3,
                  child: CircularButton(
                    color: Colors.blue,
                    width: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                    height: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: size.height * 0.05,
                    ),
                    onClick: (_bookIndex == _unitSort-1)? _isLastUnit
                        :(widget.type == 'reading')? () async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex+1], learns[4].type, learns[4].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex+1].unitSeq,_bookSeq,(_bookIndex+1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex+1], type: 'reading',)
                      ));
                    } :() async{
                      assetsAudioPlayer.stop();
                      setState(() {
                        soundClick = '0';
                      });
                      List<Question> questions =  await getQuestions(units[_bookIndex+1], learns[5].type, learns[5].code);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex+1].unitSeq,_bookSeq,(_bookIndex+1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex+1], type: 'listening',)
                      ));
                    },
                  ),
                ),
              ),
              Positioned(
                left: size.width * 0.425,
                bottom: size.height * 0.02,
                child: Material(
                  elevation: 3,
                  borderRadius: new BorderRadius.circular(size.height * 0.1),
                  child: Row(
                    children: <Widget>[
                      (soundClick == '0') ? IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.playCircle,
                          size: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () async {
                          assetsAudioPlayer.open(
                              Playlist(
                                  audios: playList
                              ),
                              headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug
                          );
                          setState(() {
                            soundClick = '1';
                          });
                          assetsAudioPlayer.playlistFinished.listen((data) {
                            if(data == true){
                              setState(() {
                                soundClick = '0';
                              });
                            }
                          });
                        },
                        iconSize: size.width < 700 ? size.height * 0.11 : size.height * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ) : (soundClick == '1') ? IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.pauseCircle,
                          size: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () async{
                          assetsAudioPlayer.pause();
                          setState(() {
                            soundClick = '2';
                          });
                        },
                        iconSize: size.width < 700 ? size.height * 0.11 : size.height * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ) : IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.playCircle,
                          size: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () async{
                          assetsAudioPlayer.play();
                          setState(() {
                            soundClick = '1';
                          });
                        },
                        iconSize: size.width < 700 ? size.height * 0.11 : size.height * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.stopCircle,
                          size: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                          gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.lightBlueAccent
                            ],
                          ),
                        ),
                        onPressed: () {
                          assetsAudioPlayer.stop();
                          setState(() {
                            soundClick = '0';
                          });
                        },
                        iconSize: size.width < 700 ? size.height * 0.11 : size.height * 0.09,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
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
                        height: size.width * 0.24,
                        width: size.height * 0.38,
                      ),
                    ),
                    (widget.type == 'listening') ?
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(170), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
                          height: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
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
                                    width: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    height: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
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
                                    width: size.width < 700 ? size.height * 0.02 : size.height * 0.015,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: 0.5,
                                        child: GradientText("한",
                                            gradient: LinearGradient(
                                                colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                            style: TextStyle(fontSize: size.width < 700 ? size.height * 0.055 : size.height * 0.045, fontWeight: FontWeight.bold),
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
                                    width: size.height * 0.03,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      GradientIcon(
                                        icon: FontAwesomeIcons.font,
                                        size: size.width < 700 ? size.height * 0.07 : size.height * 0.05,
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
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (widget.type == 'reading')? () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, learns[4].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'eng', textVoca: 'text')
                                  ));
                                } : () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[5].type, learns[5].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'eng', textVoca: 'text')
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
                    ) :
                    SizedBox(
                      width: size.width * 0,
                      height: size.width * 0,
                    ),
                    (widget.type == 'listening') ?
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(200), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
                          height: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
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
                                    width: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    height: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
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
                                    width: size.height * 0.015,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: 0.5,
                                        child: GradientIcon(
                                          icon: FontAwesomeIcons.font,
                                          size: size.width < 700 ? size.height * 0.055 : size.height * 0.045,
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
                                    width: size.height * 0.035,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: size.height * 0.015,
                                      ),
                                      GradientText("한",
                                          gradient: LinearGradient(
                                              colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                          style: TextStyle(fontSize: size.width < 700 ? size.height * 0.068 : size.height * 0.053, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (widget.type == 'reading')? () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, learns[4].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'kor', textVoca: 'text')
                                  ));
                                } : () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[5].type, learns[5].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'kor', textVoca: 'text')
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
                    ) :
                    SizedBox(
                      width: size.width * 0,
                      height: size.width * 0,
                    ),
                    (widget.type == 'listening') ?
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(230), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
                          height: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
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
                                    width: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    height: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientIcon(
                                icon: FontAwesomeIcons.headphones,
                                size: size.width < 700 ? size.height * 0.08 : size.height * 0.06,
                                gradient: new LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ],
                                ),
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: (widget.type == 'reading')? () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, learns[4].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'sound', textVoca: 'text')
                                  ));
                                } : () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[5].type, learns[5].code);
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'sound', textVoca: 'text')
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
                    ) :
                    SizedBox(
                      width: size.width * 0,
                      height: size.width * 0,
                    ),
                    Transform.translate(
                      offset:
                      (widget.type == 'reading')?
                      Offset.fromDirection(
                          getRadiansFromDegree(220), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2) :
                      Offset.fromDirection(
                          getRadiansFromDegree(260), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
                          height: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
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
                                    width: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    height: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientIcon(
                                icon: FontAwesomeIcons.question,
                                size: size.width < 700 ? size.height * 0.08 : size.height * 0.06,
                                gradient: new LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ],
                                ),
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  List<Question> questions =  await getQuestions(widget.unit, learns[4].type, '207');
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => (widget.type == 'listening')? QuizPage(questions: questions, playlist: playList, unit: widget.unit, sentence: sentenceEng, code: '207', type: 'listening') :
                                      QuizPage(questions: questions, unit: widget.unit, sentence: sentenceEng, code: '207', type: 'reading')
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
                      (widget.type == 'reading')?
                      Offset.fromDirection(
                          getRadiansFromDegree(250), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2):
                      Offset.fromDirection(
                          getRadiansFromDegree(290), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
                          height: size.width < 700 ? size.height * 0.12 : size.height * 0.1,
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
                                    width: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    height: size.width < 700 ? size.height * 0.1 : size.height * 0.08,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("V",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.height * 0.09 : size.height * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.12,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  assetsAudioPlayer.stop();
                                  setState(() {
                                    soundClick = '0';
                                  });
                                  try{
                                    List<Question> questions =  await getVocaQuestions(widget.unit, 'text', '101', _memberSeq);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => VocaListPage(questions: questions, unit: widget.unit)
                                    ));
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("지문에 해당하는 단어가 없습니다."), duration: Duration(milliseconds: 800),
                                    ));
                                  }
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
                    Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width < 700 ? size.height * 0.16 : size.height * 0.13,
                        height: size.width < 700 ? size.height * 0.16 : size.height * 0.13,
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
                                  width: size.width < 700 ? size.height * 0.05 : size.height * 0.04,
                                  height: size.width < 700 ? size.height * 0.05 : size.height * 0.04,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(size.width * 0.8),
                                  ),
                                ),
                              ],
                            ),
                            MaterialButton(
                              height: size.width < 700 ? size.height * 0.14 : size.height * 0.12,
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
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.width * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {

    Size size = MediaQuery.of(context).size;

  }

  void _isFirstUnit() {
    _key.currentState.showSnackBar(SnackBar(
      content: Text("첫 번째 지문입니다."),
    ));
    return;
  }

  void _isLastUnit() {
    _key.currentState.showSnackBar(SnackBar(
      content: Text("마지막 지문입니다."),
    ));
    return;
  }
}