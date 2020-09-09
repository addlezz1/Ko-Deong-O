import 'package:assets_audio_player/assets_audio_player.dart';
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
import 'package:talkwho/ui/pages/study1_page.dart';
import 'package:talkwho/ui/pages/study2_page.dart';
import 'package:talkwho/ui/pages/text_list.dart';
import 'package:talkwho/ui/widgets/circular_button.dart';
import 'package:talkwho/ui/widgets/gradient_icon.dart';

import 'home.dart';

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
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  List<Learn> learns = List();
  List<Unit> units = List<Unit>(999);

  bool _isClicked = false;
  bool _isSaved;

  String _memberSeq = '';
  String _bookSeq = '';
  String _categoryName = '';
  String _bookName = '';
  String soundClick = '0';
  int _bookIndex = 0;
  int _unitSort = 0;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

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
    _getLearn();
    _getCurrentUnit();
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
    List<Audio> playList = new List<Audio>();
    for (var i = 0; i < widget.questions.length; i++) {
      playList.add(Audio.network(widget.questions[i].audioUrl));
    }
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async{
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
              ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: widget.questions.length + 1,
                itemBuilder: _buildItem,
              ),
              Positioned(
                left: size.width * 0.02,
                bottom: size.height * 0.455,
                child: Opacity(
                  opacity: 0.3,
                  child: CircularButton(
                    color: Colors.blue,
                    width: size.width * 0.12,
                    height: size.width * 0.12,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onClick: (_bookIndex == 0)? _isFirstUnit
                        : () async{
                      List<Question> questions =  await getVocaQuestions(units[_bookIndex-1], 'text', '101', _memberSeq);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex-1].unitSeq,_bookSeq,(_bookIndex-1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => VocaListPage(questions: questions, unit: units[_bookIndex-1])
                      ));
                    },
                  ),
                ),
              ),
              Positioned(
                left: size.width * 0.34,
                bottom: size.height * 0.02,
                child: Material(
                  elevation: 3,
                  borderRadius: new BorderRadius.circular(size.width * 0.1),
                  child: Row(
                    children: <Widget>[
                      (soundClick == '0') ? IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.playCircle,
                          size: size.width * 0.1,
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
                        iconSize: size.width * 0.11,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ) : (soundClick == '1') ? IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.pauseCircle,
                          size: size.width * 0.1,
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
                        iconSize: size.width * 0.11,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ) : IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.playCircle,
                          size: size.width * 0.1,
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
                        iconSize: size.width * 0.11,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      IconButton(
                        icon: GradientIcon(
                          icon: FontAwesomeIcons.stopCircle,
                          size: size.width * 0.1,
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
                        iconSize: size.width * 0.11,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: size.width * 0.02,
                bottom: size.height * 0.455,
                child: Opacity(
                  opacity: 0.3,
                  child: CircularButton(
                    color: Colors.blue,
                    width: size.width * 0.12,
                    height: size.width * 0.12,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onClick: (_bookIndex == _unitSort-1)? _isLastUnit
                        :() async{
                      List<Question> questions =  await getVocaQuestions(units[_bookIndex+1], 'text', '101', _memberSeq);
                      CurrentLearn currentLearn = await getCurrentLearn(_memberSeq,units[_bookIndex+1].unitSeq,_bookSeq,(_bookIndex+1).toString(),_categoryName,_bookName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => VocaListPage(questions: questions, unit: units[_bookIndex+1])
                      ));
                    },
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
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'eng', textVoca: 'voca')
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
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'kor', textVoca: 'voca')
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
                                      builder: (_) => Study1Page(questions: questions, unit: widget.unit, type: 'sound', textVoca: 'voca')
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
                    AnimatedOpacity(
                      opacity: (_isClicked == false)? 0.5 : 1.0,
                      duration: Duration(milliseconds: 300),
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
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {

    Size size = MediaQuery.of(context).size;

    if(index == widget.questions.length) {
      return SizedBox(
        height: size.height * 0.1,
      );
    }
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
                maxLines: 1,
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
                    fontSize: 15.0
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
  void _isFirstUnit() {
    _key.currentState.showSnackBar(SnackBar(
      content: Text("첫 번째 단어장입니다."),
    ));
    return;
  }

  void _isLastUnit() {
    _key.currentState.showSnackBar(SnackBar(
      content: Text("마지막 단어장입니다."),
    ));
    return;
  }
}