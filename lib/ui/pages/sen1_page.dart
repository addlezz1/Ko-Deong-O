import 'package:flutter/material.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:talkwho/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tags/flutter_tags.dart';

class Sen1Page extends StatefulWidget {
  final List<Question> questions;
  final Unit unit;

  const Sen1Page({Key key, @required this.questions, this.unit}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<Sen1Page> {
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


  final List<String> _list = [
    'My',
    'Heart',
    'Facebook',
    'Kirchhoff',
    'Italy',
    'France',
    'Spain',
  ];

  bool _symmetry = false;
  bool _removeButton = true;
  bool _singleItem = false;
  bool _startDirection = false;
  bool _horizontalScroll = false;
  bool _withSuggesttions = false;
  bool _firstPress = true;
  int _count = 0;
  int _column = 0;
  double _fontSize = 24;

  String _itemCombine = 'withTextBefore';

  String _onPressed = '';
  String currentText = '';

  //List _items;

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  void initState() {
    super.initState();
    //_items = _list.toList();
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
  }

  void _setText(item) {
    setState(() {
      //currentText = currentText + ' ' + item.title ;
      currentText = currentText + item.title ;
      _firstPress = false;
    });

  }

  void _deleteText() {
    setState(() {
      currentText = currentText.substring(0,currentText.length-1);
    });
  }

  void _clearText() {
    setState(() {
      currentText = '';
    });
  }

  @override
  Widget build(BuildContext context){

    Size size = MediaQuery.of(context).size;
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.words;
    //options.shuffle();

    /*if(!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }*/
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
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(HtmlUnescape().convert(widget.questions[_currentIndex].question),
                          softWrap: true,
                          style: _questionStyle,),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Material(
                              elevation: 24.0,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(currentText,style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0
                                ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Tags(
                        key: _tagStateKey,
                        symmetry: _symmetry,
                        columns: _column,
                        horizontalScroll: _horizontalScroll,
                        //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
                        heightHorizontalScroll: 60 * (_fontSize / 14),
                        itemCount: options.length,
                        itemBuilder: (index) {
                          final item = options[index];

                          return ItemTags(
                            key: Key(index.toString()),
                            index: index,
                            title: item,
                            pressEnabled: true,
                            activeColor: Colors.blueGrey[600],
                            singleItem: _singleItem,
                            splashColor: Colors.green,
                            combine: ItemTagsCombine.withTextBefore,

                            textScaleFactor:
                            utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
                            textStyle: TextStyle(
                              fontSize: _fontSize,
                            ),
                            onPressed: (item) => _setText(item),
                          );
                        },
                      )
                      /*...options.map((option)=>RadioListTile(
                          title: Text(HtmlUnescape().convert("$option")),
                          groupValue: _answers[_currentIndex],
                          value: option,
                          onChanged: (value){
                            setState(() {
                              _answers[_currentIndex] = option;
                            });
                          },
                        )),*/
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          child: Text("Delete"),
                          onPressed: _deleteText,
                          onLongPress: _deleteText,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          child: Text("Clear"),
                          onPressed: _clearText,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          child: Text( _currentIndex == (widget.questions.length - 1) ? "Submit" : "Next"),
                          onPressed: _nextSubmit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {

    _answers[_currentIndex] = currentText;
    currentText = '';
    if(_answers[_currentIndex] == '') {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("철자를 입력해주세요"),
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