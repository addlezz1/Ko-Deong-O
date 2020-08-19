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

class Study2Page extends StatefulWidget {
  final List<Question> questions;
  final Unit unit;

  const Study2Page({Key key, @required this.questions, this.unit}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<Study2Page> {
  final TextStyle _questionStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.white
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
    if(!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }
   //print(question.audioUrl);
    //advancedPlayer.play(question.audioUrl);
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
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                height: 200,
              ),
            ),
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
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: Text(HtmlUnescape().convert(widget.questions[_currentIndex].question),
                          softWrap: true,
                          style: _questionStyle,),
                      ),


                    ],
                  ),
                  question.mediaUrl =='http://talkwho.whitesoft.net/'?
                      Container(
                        alignment: Alignment(1,1),
                        height: size.height * 0.25,
                      )
                    : Container(
                      alignment: Alignment(1, 1),
                      //width: MediaQuery.of(context).size.width,
                      height: size.height * 0.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          //fit: BoxFit.fill,
                          image: NetworkImage(
                              question.mediaUrl),
                        ),
                      ),
                    ),

                  SizedBox(height: size.height * 0.05),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...options.map((option)=>RadioListTile(
                          title: Text(HtmlUnescape().convert("$option")),
                          groupValue: _answers[_currentIndex],
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
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        child: Text( _currentIndex == (widget.questions.length - 1) ? "Submit" : "Next"),
                        onPressed: _nextSubmit,
                      ),
                    ),
                  )
                ],
              ),
            )
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
        builder: (_) => QuizFinishedPage(questions: widget.questions, answers: _answers)
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