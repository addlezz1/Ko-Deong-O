import 'package:flutter/material.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:talkwho/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Unit unit;
  final String sentence;
  final String code;

  const QuizPage({Key key, @required this.questions, this.unit, @required this.sentence, @required this.code}) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
  }



  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    Question question = widget.questions[_currentIndex];
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex+1}"),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(HtmlUnescape().convert(widget.questions[_currentIndex].question),
                          softWrap: true,

                          style: _questionStyle,),
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

                  (question?.mediaUrl != 'http://talkwho.whitesoft.net/')
                    ? Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _isImageShown = !_isImageShown),
                      child: new Image.network(question.mediaUrl,height: 150,fit: BoxFit.fill,
                      ),
                    )
                  )
                      :SizedBox(height: size.height * 0.01),

                  (question?.mediaUrl != 'http://talkwho.whitesoft.net/')
                    ? Center(
                      child: GestureDetector(
                        onTap: () => setState(() => _isImageShown = !_isImageShown),
                        child: new Image.network(question.mediaUrl,height: 300,fit: BoxFit.fill,
                        ),
                      )
                  )
                      :SizedBox(height: size.height * 0.01),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 18.0),
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
                                  fontSize: 16.0,
                                  height: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: SizedBox(
                      height: size.height * 0.3,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ...options.map((option)=>RadioListTile(
                              title: Text(HtmlUnescape().convert("$option"), style: TextStyle(fontSize: 14.0),),
                              groupValue: _answers[_currentIndex],
                              activeColor: Colors.blueAccent,
                              value: option,
                              onChanged: (value){
                                setState(() {
                                  _answers[_currentIndex] = option;
                                });
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * 0.3,
                      height: size.height * 0.05,
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
            ),
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if(_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("You must select an answer to continue."),
      ));
      return;
    }
    if(_currentIndex < (widget.questions.length - 1)){
      setState(() {
          _currentIndex++;
      });
    } else {
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
                advancedPlayer.stop();
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