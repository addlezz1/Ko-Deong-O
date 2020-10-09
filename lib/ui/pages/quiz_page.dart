import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:talkwho/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:talkwho/ui/widgets/circular_button.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final List<Audio> playlist;
  final Unit unit;
  final String sentence;
  final String code;
  final String type;

  const QuizPage({Key key, @required this.questions, this.playlist, this.unit, @required this.sentence, @required this.code, @required this.type}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _isImageShown = false;
  final TextStyle _questionStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Colors.black
  );

  int _currentIndex = 0;
  final Map<int,dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }

    if(widget.type == 'listening') {
      assetsAudioPlayer.open(
        Playlist(
            audios: widget.playlist
        ),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug
        );
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
    Size size = MediaQuery.of(context).size;
    Question question = widget.questions[_currentIndex];
    print(question.mediaUrl);
    final List<dynamic> options = question.incorrectAnswers;
    for(int i = 4; i>=0; i--) {
      if(question?.incorrectAnswers[i] == null) {
        options.remove(options[i]);
      }
    }
    if(!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }
    advancedPlayer.play(question.audioUrl);
    
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(widget.unit.unitName),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(size.height * 0.01),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: size.height * 0.02,
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex+1}",style: TextStyle(fontSize: size.height * 0.015),),
                      ),
                      SizedBox(width: size.height * 0.02),
                      Expanded(
                        child: Text(HtmlUnescape().convert(widget.questions[_currentIndex].question,),
                          softWrap: true,

                          style: TextStyle(fontSize: size.height * 0.018),),
                      ),
                    ],
                  ),
                  /*question.mediaUrl ==''?Text("")
                    : Container(
                      alignment: Alignment(1, 1),
                      //width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          //fit: BoxFit.fill,
                          image: NetworkImage(
                              question.mediaUrl),
                        ),
                      ),
                    ),*/

                  (question?.mediaUrl != 'http://talkwho.whitesoft.net/' && widget.type == 'listening')
                    ? Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _isImageShown = !_isImageShown),
                      child: new Image.network(question.mediaUrl,height: size.height * 0.27,fit: BoxFit.fill,
                      ),
                    )
                  )
                      :SizedBox(height: size.height * 0.01),
                  (widget.type == 'reading')?Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: size.width * 0.85,
                            height: size.height * 0.3,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(HtmlUnescape().convert(widget.sentence),
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
                  ):
                  SizedBox(height: size.height * 0.01),
                  Card(
                    elevation: 2,
                    child: SizedBox(
                      height: (widget.type == 'reading')?size.height * 0.3:
                              (question?.mediaUrl == 'http://talkwho.whitesoft.net/' )?size.height * 0.63:
                              size.height * 0.36,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            ...options.map((option)=>RadioListTile(
                              title: Text(HtmlUnescape().convert("$option"), style: TextStyle(fontSize: size.height * 0.02),),
                              groupValue: _answers[_currentIndex],
                              activeColor: Colors.blueAccent,
                              value: option,
                              onChanged: (value){
                                setState(() {
                                  _answers[_currentIndex] = option;
                                });
                              },
                              dense: false,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children : <Widget>[
                      (question?.mediaUrl != 'http://talkwho.whitesoft.net/' && widget.type == 'reading')? CircularButton(
                        color: Colors.blue,
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        icon: Icon(
                          FontAwesomeIcons.image,
                          color: Colors.white,
                        ),
                        onClick: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                child: Container(
                                  height: size.height * 0.6,
                                  width: size.width * 0.95,
                                  child: Image.network(question.mediaUrl
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ) :
                      SizedBox(
                        width: size.width * 0.12,
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                      ),
                      SizedBox(
                        child: Container(
                          width: size.width * 0.3,
                          height: size.height * 0.07,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: MaterialButton(
                            child: Text( _currentIndex == (widget.questions.length - 1) ? "Submit" : "Next",style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.bold),),
                            onPressed: _nextSubmit,
                            textColor: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget landscapeMode(context){
    Size size = MediaQuery.of(context).size;
    Question question = widget.questions[_currentIndex];
    print(question.mediaUrl);
    final List<dynamic> options = question.incorrectAnswers;
    for(int i = 4; i>=0; i--) {
      if(question?.incorrectAnswers[i] == null) {
        options.remove(options[i]);
      }
    }
    if(!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }
    advancedPlayer.play(question.audioUrl);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(widget.unit.unitName),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(size.width * 0.01),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: size.width * 0.02,
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex+1}",style: TextStyle(fontSize: size.height * 0.015),),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Text(HtmlUnescape().convert(widget.questions[_currentIndex].question,),
                          softWrap: true,

                          style: TextStyle(fontSize: size.width * 0.018),),
                      ),
                    ],
                  ),
                  /*question.mediaUrl ==''?Text("")
                    : Container(
                      alignment: Alignment(1, 1),
                      //width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          //fit: BoxFit.fill,
                          image: NetworkImage(
                              question.mediaUrl),
                        ),
                      ),
                    ),*/
                  Row(
                    children: <Widget>[
                      (question?.mediaUrl != 'http://talkwho.whitesoft.net/' && widget.type == 'listening')
                          ? Center(
                          child: GestureDetector(
                            onTap: () => setState(() => _isImageShown = !_isImageShown),
                            child: new Image.network(question.mediaUrl,width: size.width * 0.45, height: size.height * 0.5, fit: BoxFit.fill,
                            ),
                          )
                      )
                          :SizedBox(height: size.width * 0.0),
                      (widget.type == 'reading')? Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: size.width * 0.45,
                                height: size.height * 0.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(HtmlUnescape().convert(widget.sentence),
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
                      ):
                      SizedBox(width: size.width * 0.0),
                      Card(
                        elevation: 2,
                        child: SizedBox(
                          width: (widget.type == 'reading')?size.width * 0.45:
                          (question?.mediaUrl == 'http://talkwho.whitesoft.net/' )?size.width * 0.45:
                          size.width * 0.45,
                          height: size.height * 0.57,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                ...options.map((option)=>RadioListTile(
                                  title: Text(HtmlUnescape().convert("$option"), style: TextStyle(fontSize: size.width * 0.02),),
                                  groupValue: _answers[_currentIndex],
                                  activeColor: Colors.blueAccent,
                                  value: option,
                                  onChanged: (value){
                                    setState(() {
                                      _answers[_currentIndex] = option;
                                    });
                                  },
                                  dense: false,
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children : <Widget>[
                      (question?.mediaUrl != 'http://talkwho.whitesoft.net/' && widget.type == 'reading')? CircularButton(
                        color: Colors.blue,
                        width: size.height * 0.12,
                        height: size.height * 0.12,
                        icon: Icon(
                          FontAwesomeIcons.image,
                          color: Colors.white,
                        ),
                        onClick: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                child: Container(
                                  height: size.width * 0.6,
                                  width: size.height * 0.95,
                                  child: Image.network(question.mediaUrl
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ) :
                      SizedBox(
                        width: size.width * 0.12,
                      ),
                      SizedBox(
                        width: size.width * 0.22,
                      ),
                      SizedBox(
                        child: Container(
                          width: size.width * 0.3,
                          height: size.height * 0.09,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.height * 0.14),
                          ),
                          child: MaterialButton(
                            child: Text( _currentIndex == (widget.questions.length - 1) ? "Submit" : "Next",style: TextStyle(fontSize: size.height * 0.042, fontWeight: FontWeight.bold),),
                            onPressed: _nextSubmit,
                            textColor: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if(_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("보기를 선택해주세요."),
      ));
      return;
    }
    if(_currentIndex < (widget.questions.length - 1)){
      setState(() {
          _currentIndex++;
      });
    } else {
      assetsAudioPlayer.stop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => QuizFinishedPage(questions: widget.questions, answers: _answers, unit: widget.unit, code: widget.code,)
      ));
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text("종료 하시겠습니까? 모든 진행 상황이 사라집니다."),
          title: Text("경고!"),
          actions: <Widget>[
            FlatButton(
              child: Text("예"),
              onPressed: (){
                assetsAudioPlayer.stop();
                Navigator.pop(context,true);
              },
            ),
            FlatButton(
              child: Text("아니오"),
              onPressed: (){
                Navigator.pop(context,false);
              },
            ),
          ],
        );
      }
    );
  }
}