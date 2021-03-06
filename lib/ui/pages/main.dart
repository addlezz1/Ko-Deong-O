import 'dart:async';
//import 'dart:html';
import 'dart:io';

import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talkwho/models/book.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talkwho/models/currentLearn.dart';
import 'package:talkwho/models/learn.dart';
import 'package:talkwho/models/question.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/category.dart';
import 'package:talkwho/ui/pages/home.dart';
import 'package:talkwho/ui/pages/login_page.dart';
import 'package:talkwho/ui/pages/save_list.dart';
import 'package:talkwho/ui/pages/study1_page.dart';
import 'package:talkwho/ui/pages/test_score.dart';
import 'package:talkwho/ui/pages/text_list.dart';
import 'package:talkwho/ui/pages/voca_list.dart';
import 'package:talkwho/ui/widgets/circular_button.dart';
import 'package:talkwho/ui/widgets/gradient_icon.dart';
import 'error.dart';
import 'unit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradient_text/gradient_text.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> with TickerProviderStateMixin{

  SharedPreferences _sharedPreferences;

  List<Book> books = List();
  List<Learn> learns = List();
  List<Unit> units = List<Unit>(999);


  String _loginUserName = '';
  String _loginNickName = '';
  String _memberSeq = '';
  String _unitSeq = '';
  String _bookSeq = '';
  String _title = '';
  String _categoryName = '';
  String _bookName = '';
  String _studentImage = '';
  int _bookIndex = 0;

  AnimationController animationController;
  AnimationController animationController_2;
  Animation degOneTranslationAnimation, degTwoTranslationAnimation, degThreeTranslationAnimation;
  Animation rotationAnimation;
  Tween<double> slideTween = Tween(begin: 0.0, end: 200.0);
  Tween<double> borderTween = Tween (begin: 0.0, end: 40.0); /// Add radius range
  Animation<double> slideAnimation;
  Animation<double> borderAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }


  void _getLearn() async {
    List<Learn> learn =  await getLearn(units[_bookIndex]);
    if(this.mounted) {
      setState(() {
        learns = learn;
        //print(learns[0].code);
        //왜 계속 print 가 될까...
      });
    }
  }

  void _getCurrentUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String loginUserName = prefs.getString('loginUserName');
    String loginNickName = prefs.getString('loginNickName');
    String memberSeq = prefs.getString('memberSeq');
    String studentImage = prefs.getString('studentImage');
    if (this.mounted) {
      setState(() {
        _loginUserName = loginUserName;
        _loginNickName = loginNickName;
        _studentImage = studentImage;
        _memberSeq = memberSeq;
      });
    }
    if(_memberSeq != null) {
      CurrentLearn currentUnit = await getCurrentUnit(_memberSeq);
      //print(currentUnit.unitSeq);
      if(currentUnit.unitSeq != '0') {
        _unitSeq = currentUnit.unitSeq;
        _bookSeq = currentUnit.bookSeq;
        _categoryName = currentUnit.categoryName;
        _bookName = currentUnit.bookName;
        //_title = currentUnit.title;
      }

      if (currentUnit.bookIndex != null) {
        _bookIndex = int.parse(currentUnit.bookIndex);
        //print(_bookSeq);
      }
    }
    if(_unitSeq != '') {
      List<Unit> unit = await getUnit(_bookSeq);
      //print(units[_bookIndex].unitName);
      //print(units[_bookIndex].unitSeq);
      if (this.mounted) {
        setState(() {
          units = unit;
        });
      }
    }
  }

  @override
  void initState(){
    super.initState();
    if(_memberSeq != null) {
      _getCurrentUnit();
    }
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    animationController_2 = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));

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

    //slideAnimation = slideTween.animate(CurvedAnimation(parent: animationController_2, curve: Curves.linear));
    //borderAnimation = borderTween.animate(CurvedAnimation(parent: animationController_2, curve: Curves. linear)); // Define corner radius animation

    slideAnimation = slideTween.animate(CurveTween(curve: Interval(0.0, 0.9, curve: Curves.linear)).animate(animationController_2));
    borderAnimation = borderTween.animate(CurveTween(curve: Interval(0.9, 1.0, curve: Curves.linear)).animate(animationController_2));

    animationController.addListener(() {
    });
    animationController_2.repeat(reverse: true);

  }

  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    animationController.dispose();
    animationController_2.dispose();
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
    if(units[_bookIndex]?.category != null) {
      _getLearn();
    }
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('고등語', style: TextStyle(fontSize: size.height * 0.02),),
          elevation: 0,
        ),
        drawer: new Drawer(
          child: new ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              new UserAccountsDrawerHeader(
                  accountName: new Text(_loginUserName != '' ? _loginUserName.toString() : '로그인 해주세요', style: TextStyle(fontSize: size.height * 0.015),),
                  accountEmail: new Text(_loginNickName != '' ? _loginNickName.toString() : '', style: TextStyle(fontSize: size.height * 0.015),),
                  currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: (_studentImage == "http://talkwho.whitesoft.net/") ?
                    AssetImage('assets/images/no_profile.png')
                    : NetworkImage(_studentImage),
                  ),
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.height * 0.01),
                title: new Text('저장한 단어', style: TextStyle(fontSize: size.height * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.save,
                  size: size.height * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveListPage()),
                  );
                },
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.height * 0.01),
                title: new Text('단어장 바꾸기', style: TextStyle(fontSize: size.height * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.exchangeAlt,
                  size: size.height * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'none',)),
                  );
                },
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.height * 0.01),
                title: new Text('피드백 보기', style: TextStyle(fontSize: size.height * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.commentDots,
                  size: size.height * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.height * 0.01),
                title: new Text('퀴즈 점수 보기', style: TextStyle(fontSize: size.height * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.star,
                  size: size.height * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestScorePage()),
                  );
                },
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.height * 0.01),
              //color: (_page == 4) ? Colors.black : Colors.grey),
                title: new Text('로그아웃', style: TextStyle(fontSize: size.height * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.signOutAlt,
                  size: size.height * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: () async {
                  await _logout();
                  },
              ),
            ],
          ),
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
          child: Stack(
            children: [
              /*Container(
                margin: EdgeInsets.only(left: slideAnimation.value),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderAnimation.value),
                  color: Colors.blue,
                ),
                width: 80,
                height: 80,
              ),*/
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GradientText("현재 진행중인 번호",
                        gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                        style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.8,
                          height: size.height * 0.08,
                          decoration: new BoxDecoration(
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
                          ),
                          child: MaterialButton(
                            elevation: 1.0,
                            highlightElevation: 1.0,
                            onPressed: ()async{
                              if(_bookName == 'Reading'){
                                List<Question> questions =  await getQuestions(units[_bookIndex], 'text', '201');
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'reading',)
                                ));
                              } else if(_bookName == 'Listening'){
                                List<Question> questions =  await getQuestions(units[_bookIndex], 'text', '202');
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'listening',)
                                ));
                              } else if(_bookName.substring(0,4) == 'Voca'){
                                List<Question> questions =  await getVocaQuestions(units[_bookIndex], 'text', '101', _memberSeq);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => VocaListPage(questions: questions, unit: units[_bookIndex])
                                ));
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(size.width * 0.1),
                            ),
                            textColor: Colors.white70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                units[_bookIndex]?.unitSeq == null ?
                                Text('영어 세트를 지정해주세요',style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.bold),):
                                AutoSizeText(
                                  //?를 붙이면 nullException 이 가능하다
                                  _categoryName + ' ' + _bookName + ' ' + units[_bookIndex].unitName,
                                  minFontSize: 10,
                                  style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  wrapWords: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /*Positioned(
                left: size.width * 0.0,
                bottom: size.height * 0.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Arc(
                    arcType: ArcType.CONVEX,
                    edge: Edge.TOP,
                    height: size.width * 0.2,
                    child: new Container(
                      height: size.width * 0.5,
                      width: size.width,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),*/
              Positioned(
                left: size.width < 700 ? size.width * 0.15 : size.width * 0.22,
                bottom: size.height * -0.16,
                child:               Container(
                  width: size.width < 700 ? size.width * 0.7: size.width * 0.56,
                  height: size.width < 700 ? size.width * 0.7: size.width * 0.56,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size.width * 0.6),
                  ),
                ),
              ),
              Positioned(
                left: size.width * 0.185,
                bottom: size.height * 0.01,
                child: Stack(
                  //시작점을 잡아준다 -> ignorePointer 의 기준점 설정 가능
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    //translate 될 때 변화를 무시해줄 수 있는 포인터 AbsorbPointer 도 있음
                    IgnorePointer(
                      child: Container(
                        //padding: const EdgeInsets.only(left: 100.0),
                        color: Colors.black.withOpacity(0.0),
                        height: size.height * 0.22,
                        width: size.width * 0.63,
                      ),
                    ),
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(180), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                                    height: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("S",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.width * 0.09 : size.width * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    //List<Question> questions =  await getQuestions(units[_bookIndex], learns[5].type, learns[5].code);
                                    //Navigator.push(context, MaterialPageRoute(
                                    //    builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'listening',)
                                    //));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'S',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(240), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                                    height: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("L",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.width * 0.09 : size.width * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    /*print(learns[5].code);
                                    List<Question> questions =  await getQuestions(units[_bookIndex], learns[5].type, learns[5].code);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'listening',)
                                    ));*/
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'L',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(300), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                                    height: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("R",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.width * 0.09 : size.width * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    /*print(learns[4].type);
                                    print( learns[4].code);
                                    List<Question> questions =  await getQuestions(units[_bookIndex], learns[4].type, learns[4].code);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'reading',)
                                    ));*/
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'R',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(360), size.width < 700 ? degOneTranslationAnimation.value * size.width * 0.23 : degOneTranslationAnimation.value * size.width * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
                                    height: size.width < 700 ? size.width * 0.12 : size.width * 0.09,
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
                                height: size.width < 700 ? size.width * 0.14 : size.width * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    /*List<Question> questions =  await getVocaQuestions(units[_bookIndex], learns[0].type, learns[0].code, _memberSeq);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => VocaListPage(questions: questions, unit: units[_bookIndex],)
                                    ));*/
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'V',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                              height: size.width < 700 ? size.width * 0.16 : size.width * 0.13,
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
              )
            ],
          ),
        )
    );
  }

  Widget landscapeMode(context){

    Size size = MediaQuery.of(context).size;
    if(units[_bookIndex]?.category != null) {
      _getLearn();
    }
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('고등語'),
          elevation: 0,
        ),
        drawer: new Drawer(
          child: new ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(_loginUserName != '' ? _loginUserName.toString() : '로그인 해주세요', style: TextStyle(fontSize: size.width * 0.015),),
                accountEmail: new Text(_loginNickName != '' ? _loginNickName.toString() : '', style: TextStyle(fontSize: size.width * 0.015),),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: (_studentImage == "http://talkwho.whitesoft.net/") ?
                  AssetImage('assets/images/no_profile.png')
                      : NetworkImage(_studentImage),
                ),
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.width * 0.01),
                title: new Text('저장한 단어', style: TextStyle(fontSize: size.width * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.save,
                  size: size.width * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveListPage()),
                  );
                },
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.width * 0.01),
                title: new Text('단어장 바꾸기', style: TextStyle(fontSize: size.width * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.exchangeAlt,
                  size: size.width * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'none',)),
                  );
                },
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.width * 0.01),
                title: new Text('피드백 보기', style: TextStyle(fontSize: size.width * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.commentDots,
                  size: size.width * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.width * 0.01),
                title: new Text('퀴즈 점수 보기', style: TextStyle(fontSize: size.width * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.star,
                  size: size.width * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestScorePage()),
                  );
                },
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(size.width * 0.01),
                //color: (_page == 4) ? Colors.black : Colors.grey),
                title: new Text('로그아웃', style: TextStyle(fontSize: size.width * 0.02),),
                trailing: GradientIcon(
                  icon: FontAwesomeIcons.signOutAlt,
                  size: size.width * 0.03,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlueAccent
                    ],
                  ),
                ),
                onTap: () async {
                  await _logout();
                },
              ),
            ],
          ),
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
          child: Stack(
            children: [
              /*Container(
                margin: EdgeInsets.only(left: slideAnimation.value),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderAnimation.value),
                  color: Colors.blue,
                ),
                width: 80,
                height: 80,
              ),*/
              Positioned(
                left: size.width < 700 ? size.width * 0.3: size.width * 0.32,
                bottom: size.height * -0.2,
                child:               Container(
                  width: size.width < 700 ? size.width * 0.4: size.width * 0.36,
                  height: size.width < 700 ? size.width * 0.4: size.width * 0.36,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size.width * 0.6),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GradientText("현재 진행중인 번호",
                        gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                        style: TextStyle(fontSize: size.height * 0.042, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.height * 0.8,
                          height: size.width * 0.08,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                            borderRadius: BorderRadius.circular(size.height * 0.1),
                          ),
                          child: MaterialButton(
                            elevation: 1.0,
                            highlightElevation: 1.0,
                            onPressed: ()async{
                              if(_bookName == 'Reading'){
                                List<Question> questions =  await getQuestions(units[_bookIndex], 'text', '201');
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'reading',)
                                ));
                              } else if(_bookName == 'Listening'){
                                List<Question> questions =  await getQuestions(units[_bookIndex], 'text', '202');
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'listening',)
                                ));
                              } else if(_bookName.substring(0,4) == 'Voca'){
                                List<Question> questions =  await getVocaQuestions(units[_bookIndex], 'text', '101', _memberSeq);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => VocaListPage(questions: questions, unit: units[_bookIndex])
                                ));
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(size.height * 0.1),
                            ),
                            textColor: Colors.white70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                units[_bookIndex]?.unitSeq == null ?
                                Text('영어 세트를 지정해주세요',style: TextStyle(fontSize: size.height * 0.042, fontWeight: FontWeight.bold),):
                                AutoSizeText(
                                  //?를 붙이면 nullException 이 가능하다
                                  _categoryName + ' ' + _bookName + ' ' + units[_bookIndex].unitName,
                                  minFontSize: 10,
                                  style: TextStyle(fontSize: size.height * 0.042, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  wrapWords: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /*Positioned(
                left: size.width * 0.0,
                bottom: size.height * 0.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Arc(
                    arcType: ArcType.CONVEX,
                    edge: Edge.TOP,
                    height: size.width * 0.2,
                    child: new Container(
                      height: size.width * 0.5,
                      width: size.width,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),*/
              Positioned(
                left: size.width * 0.285,
                bottom: size.height * 0.01,
                child: Stack(
                  //시작점을 잡아준다 -> ignorePointer 의 기준점 설정 가능
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    //translate 될 때 변화를 무시해줄 수 있는 포인터 AbsorbPointer 도 있음
                    IgnorePointer(
                      child: Container(
                        //padding: const EdgeInsets.only(left: 100.0),
                        color: Colors.black.withOpacity(0.0),
                        height: size.height * 0.42,
                        width: size.width * 0.43,
                      ),
                    ),
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(180), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                                    height: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("S",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.height * 0.09 : size.height * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    //List<Question> questions =  await getQuestions(units[_bookIndex], learns[5].type, learns[5].code);
                                    //Navigator.push(context, MaterialPageRoute(
                                    //    builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'listening',)
                                    //));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'S',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(240), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                                    height: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("L",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.height * 0.09 : size.height * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    /*print(learns[5].code);
                                    List<Question> questions =  await getQuestions(units[_bookIndex], learns[5].type, learns[5].code);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'listening',)
                                    ));*/
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'L',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(300), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                                    height: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(size.width * 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              GradientText("R",
                                  gradient: LinearGradient(
                                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                                  style: TextStyle(fontSize: size.width < 700 ? size.height * 0.09 : size.height * 0.07, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center
                              ),
                              MaterialButton(
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    /*print(learns[4].type);
                                    print( learns[4].code);
                                    List<Question> questions =  await getQuestions(units[_bookIndex], learns[4].type, learns[4].code);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => TextListPage(questions: questions, unit: units[_bookIndex],type: 'reading',)
                                    ));*/
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'R',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                    Transform.translate(
                      offset:
                      Offset.fromDirection(
                          getRadiansFromDegree(360), size.width < 700 ? degOneTranslationAnimation.value * size.height * 0.23 : degOneTranslationAnimation.value * size.height * 0.2),
                      child: Transform(
                        transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                            borderRadius: BorderRadius.circular(size.width * 0.14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
                                    height: size.width < 700 ? size.height * 0.12 : size.height * 0.09,
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
                                height: size.width < 700 ? size.height * 0.14 : size.height * 0.11,
                                elevation: 1.0,
                                highlightElevation: 1.0,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async{
                                  try{
                                    /*List<Question> questions =  await getVocaQuestions(units[_bookIndex], learns[0].type, learns[0].code, _memberSeq);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => VocaListPage(questions: questions, unit: units[_bookIndex],)
                                    ));*/
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryPage(bookValue :'V',)),
                                    );
                                  } catch(e){
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("준비중입니다"), duration: Duration(milliseconds: 500),
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
                              height: size.width < 700 ? size.height * 0.16 : size.height * 0.13,
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
              )
            ],
          ),
        )
    );
  }

  /*Widget _buildCategoryItem(BuildContext context, int index) {

    Book book = books[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, book),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          SizedBox(height: 5.0),
          AutoSizeText(
            book.bookName,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,),
        ],
      ),
    );
  }*/
  /*_categoryPressed(BuildContext context,Book book) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => UnitPage( book: book,)
    ));
  }*/

  _logout() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    if(this.mounted) {
      setState(() {
        _sharedPreferences.setString('loginID', null);
        _sharedPreferences.setString('loginPassword', '');
        _sharedPreferences.setString('loginUserName', '');
        _sharedPreferences.setString('loginNickName', '');
        _sharedPreferences.setString('memberSeq', '0');
        _sharedPreferences.setString('classSeq', '');
        //print(_loginUserName);
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage(),),);
      });
    }
  }

  void _study1(Learn learn) async {
    if(this.mounted) {
      setState(() {
        //processing = true;
      });
    }
    try {
      List<Question> questions =  await getQuestions(units[_bookIndex], 'voca', '101');
      //FlashCard
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => Study1Page(questions: questions, unit: units[_bookIndex],)
    ));
      print(learn.code);

    }on SocketException catch (_) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => ErrorPage(message: "Can't reach the servers, \n Please check your internet connection.",)
      ));
    } catch(e){
      print(e.message);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => ErrorPage(message: "Unexpected error trying to connect to the API",)
      ));
    }
    if(this.mounted) {
      setState(() {
        //processing = false;
      });
    }
  }

}