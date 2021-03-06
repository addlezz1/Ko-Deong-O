import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talkwho/models/register.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/style/theme.dart' as Theme;
import 'package:talkwho/ui/pages/home.dart';
import 'package:talkwho/utils/bubble_indication_painter.dart';
import 'package:talkwho/models/login.dart';
import 'package:talkwho/models/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/profile.dart';
import '../../resources/api_provider.dart';


class LoginPage extends StatefulWidget {
  final Login logins;
  const LoginPage({Key key, this.logins}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  SharedPreferences _sharedPreferences;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNickName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;
  bool _isChecked = false;

  String userID = '';
  String password = '';

  TextEditingController signupUserNameController = new TextEditingController();
  TextEditingController signupIDController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupNickNameController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();
  String school = '초등학교';
  String grade = '1학년';

  PageController _pageController;

  Color left = Colors.blueAccent;
  Color right = Colors.white;

  @override
 /*Widget build(BuildContext context){

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      key: _scaffoldKey,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return (orientation == Orientation.portrait) ?
          portraitMode(context, _scaffoldKey) : landscapeMode(
              context, _scaffoldKey);
        },
      ),
      resizeToAvoidBottomInset: true,
    );
  }*/
 //키보드가 landscape로 되어 사이즈가 이상해

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        child: (orientation == Orientation.portrait)
            ? portraitMode(context, _scaffoldKey)
            : landscapeMode(context, _scaffoldKey),
      ),
    );
  }

  Widget portraitMode(context, key) {
    Login login = widget.logins;
    Size size = MediaQuery.of(context).size;

    return NotificationListener<OverscrollIndicatorNotification>(
      child: SingleChildScrollView(
        child: Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.2),
                child: _buildMenuBar(context),
              ),
              Expanded(
                flex: 2,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    if (i == 0) {
                      if (this.mounted) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.blueAccent;
                        });
                      }
                    }  else if (i == 1) {
                      if(this.mounted) {
                        setState(() {
                          right = Colors.blueAccent;
                          left = Colors.white;
                        });
                      }
                    }
                  },
                  children: <Widget>[
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _buildSignIn(context),
                    ),
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _buildSignUp(context),
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
  Widget landscapeMode(context, key) {
    Login login = widget.logins;
    Size size = MediaQuery.of(context).size;
    return NotificationListener<OverscrollIndicatorNotification>(
      child: SingleChildScrollView(
        child: Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.2),
                child: _buildMenuBarL(context),
              ),
              Expanded(
                flex: 2,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    if (i == 0) {
                      if (this.mounted) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.blueAccent;
                        });
                      }
                    }  else if (i == 1) {
                      if(this.mounted) {
                        setState(() {
                          right = Colors.blueAccent;
                          left = Colors.white;
                        });
                      }
                    }
                  },
                  children: <Widget>[
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _buildSignInL(context),
                    ),
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _buildSignUpL(context),
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

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    Size size = MediaQuery.of(context).size;
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.03,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.745,
      height: size.height * 0.075,
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
        borderRadius: BorderRadius.all(Radius.circular(size.width * 0.07)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController, radius: size.height * 0.031,
            dxEntry: size.width * 0.07, dxTarget: size.width * 0.3, dy: size.height * 0.037),

        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "로그인",
                  style: TextStyle(
                      color: left,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.03,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "회원가입",
                  style: TextStyle(
                      color: right,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.03,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuBarL(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.745,
      height: size.height * 0.13,
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
        borderRadius: BorderRadius.all(Radius.circular(size.width * 0.07)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController, radius: size.height * 0.054,
            dxEntry: size.width * 0.07, dxTarget: size.width * 0.3, dy: size.height * 0.064),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "로그인",
                  style: TextStyle(
                      color: left,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.045,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "회원가입",
                  style: TextStyle(
                      color: right,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.045,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: size.width * 0.71,
                  height: size.height * 0.3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: size.height * 0.025,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.idCard,
                              color: Colors.blueAccent,
                              size: size.height * 0.04,
                            ),
                            hintText: "ID",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.025),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.63,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: size.height * 0.025,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: size.height * 0.04,
                              color: Colors.blueAccent,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.025),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: size.height * 0.03,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.27),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  /*boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.lightBlueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                  ],*/
                  gradient: new LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blueAccent
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.04,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () async {

                    if(loginEmailController.text == ''){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("아이디를 입력해주세요."),
                      ));
                    } else if(loginPasswordController.text == ''){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("비밀번호를 입력해주세요."),
                      ));
                    } else {
                      Profile bLogin = await getLogin(loginEmailController.text, loginPasswordController.text);
                      if (bLogin?.userID != 'none') {
                        _sharedPreferences.setString(
                            "loginUserName", bLogin.userName.toString());
                        _sharedPreferences.setString(
                            "loginNickName", bLogin.nickName.toString());
                        _sharedPreferences.setString(
                            "memberSeq", bLogin.memberSeq.toString());
                        _sharedPreferences.setString(
                            "classSeq", bLogin.classSeq.toString());
                        _sharedPreferences.setString(
                            "studentImage", bLogin.studentImage);
                        _sharedPreferences.setString(
                            "schoolGrade", bLogin.schoolGrade);
                        _sharedPreferences.setString('loginID', loginEmailController.text);
                        //if (_isChecked == true) {
                        _sharedPreferences.setString('loginPassword', loginPasswordController.text);
                        //print(bLogin.userName.toString());
                        //print(_sharedPreferences.getString("loginNickName"));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              HomePage()),
                        );
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("로그인에 실패했습니다. 아이디 또는 비밀번호를 확인해주세요."),
                        ));
                      }
                    }
                  },

                  //로그인을 누르면 메인 화면으로 넘어갈 수 있도록
                  //php 로 연결
                ),
              )
            ],
          ),
          /*Padding(
            padding: EdgeInsets.only(top: 10.0, left: 50.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Colors.blue,
                      value: _isChecked,
                      onChanged: (value){
                        if(this.mounted) {
                          setState(() {
                            _isChecked = value;
                            _sharedPreferences.setBool('isChecked', _isChecked);
                          });
                        }
                      }),
                  Text('자동 로그인',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  )
                ],
              )

          ),*/
          /*Padding(
            padding: EdgeInsets.only(top: 1.0),

            child: FlatButton(
                onPressed: () {},
                //비밀번호 찾기 화면
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),*///비밀번호 잊어버렸을
          /*Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),*/
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Facebook button pressed"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Google button pressed"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget _buildSignInL(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.05),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: size.width * 0.71,
                  height: size.height * 0.48,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 30.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: size.height * 0.04,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.idCard,
                              color: Colors.blueAccent,
                              size: size.height * 0.06,
                            ),
                            hintText: "ID",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.04),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.63,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 30.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: size.height * 0.04,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: size.height * 0.06,
                              color: Colors.blueAccent,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.04),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: size.height * 0.05,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.43),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  /*boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.lightBlueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                  ],*/
                  gradient: new LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blueAccent
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.06,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () async {

                    if(loginEmailController.text == ''){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("아이디를 입력해주세요."),
                      ));
                    } else if(loginPasswordController.text == ''){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("비밀번호를 입력해주세요."),
                      ));
                    } else {
                      Profile bLogin = await getLogin(loginEmailController.text, loginPasswordController.text);
                      if (bLogin?.userID != 'none') {
                        _sharedPreferences.setString(
                            "loginUserName", bLogin.userName.toString());
                        _sharedPreferences.setString(
                            "loginNickName", bLogin.nickName.toString());
                        _sharedPreferences.setString(
                            "memberSeq", bLogin.memberSeq.toString());
                        _sharedPreferences.setString(
                            "classSeq", bLogin.classSeq.toString());
                        _sharedPreferences.setString(
                            "studentImage", bLogin.studentImage);
                        _sharedPreferences.setString(
                            "schoolGrade", bLogin.schoolGrade);
                        _sharedPreferences.setString('loginID', loginEmailController.text);
                        //if (_isChecked == true) {
                        _sharedPreferences.setString('loginPassword', loginPasswordController.text);
                        //print(bLogin.userName.toString());
                        //print(_sharedPreferences.getString("loginNickName"));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              HomePage()),
                        );
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("로그인에 실패했습니다. 아이디 또는 비밀번호를 확인해주세요."),
                        ));
                      }
                    }
                  },

                  //로그인을 누르면 메인 화면으로 넘어갈 수 있도록
                  //php 로 연결
                ),
              )
            ],
          ),
          /*Padding(
            padding: EdgeInsets.only(top: 10.0, left: 50.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Colors.blue,
                      value: _isChecked,
                      onChanged: (value){
                        if(this.mounted) {
                          setState(() {
                            _isChecked = value;
                            _sharedPreferences.setBool('isChecked', _isChecked);
                          });
                        }
                      }),
                  Text('자동 로그인',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  )
                ],
              )

          ),*/
          /*Padding(
            padding: EdgeInsets.only(top: 1.0),

            child: FlatButton(
                onPressed: () {},
                //비밀번호 찾기 화면
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),*///비밀번호 잊어버렸을
          /*Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),*/
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Facebook button pressed"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebookF,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => showInSnackBar("Google button pressed"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String schoolGrade;

    if(school == '초등학교'){
      schoolGrade = 'P'+grade.substring(0,1);
    } else if(school == '중학교'){
      schoolGrade = 'M'+grade.substring(0,1);
    } else {
      schoolGrade = 'H'+grade.substring(0,1);
    }

    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: size.width * 0.71,
                  height: size.height * 0.57,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeName,
                            controller: signupIDController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.025,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.idCard,
                                color: Colors.blueAccent,
                                size: size.height * 0.04,
                              ),
                              hintText: "ID",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.025),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeEmail,
                            controller: signupUserNameController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.025,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.blueAccent,
                                size: size.height * 0.04,
                              ),
                              hintText: "한글 이름",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.025),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNickName,
                            controller: signupNickNameController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.025,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.font,
                                color: Colors.blueAccent,
                                size: size.height * 0.04,
                              ),
                              hintText: "영어 이름",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.025),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.school,
                                color: Colors.blueAccent,
                                size: size.height * 0.035,
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              DropdownButton<String>(
                                value: school,
                                icon: Icon(FontAwesomeIcons.caretDown),
                                iconSize: size.height * 0.025,
                                elevation: 3,
                                style: TextStyle(color: Colors.blueAccent),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String schoolValue) {
                                  setState(() {
                                    school = schoolValue;
                                  });
                                },
                                items: <String>['초등학교', '중학교', '고등학교']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontSize: size.height * 0.025),),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              DropdownButton<String>(
                                value: grade,
                                icon: Icon(FontAwesomeIcons.caretDown),
                                iconSize: size.height * 0.025,
                                elevation: 3,
                                style: TextStyle(color: Colors.blueAccent),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String gradeValue) {
                                  setState(() {
                                    grade = gradeValue;
                                  });
                                },
                                items: (school == '초등학교')? <String>['1학년', '2학년', '3학년', '4학년', '5학년', '6학년']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontSize: size.height * 0.025),),
                                  );
                                }).toList() : <String>['1학년', '2학년', '3학년']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontSize: size.height * 0.025),),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodePassword,
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.025,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.blueAccent,
                                size: size.height * 0.04,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.025),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  color: Colors.blueAccent,
                                  size: size.height * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.025,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.blueAccent,
                                size: size.height * 0.04,
                              ),
                              hintText: "Confirmation",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.025),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextSignupConfirm
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  color: Colors.blueAccent,
                                  size: size.height * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.54),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  /*boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.lightBlueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                  ],*/
                  gradient: new LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blueAccent
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.04,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed:
                        () async {

                      if (signupIDController.text == '') {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("아이디를 입력해주세요."),
                        ));
                      } else if (signupPasswordController.text == '') {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("비밀번호를 입력해주세요."),
                        ));
                      } else if (signupPasswordController.text != signupConfirmPasswordController.text) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("확인 비밀번호가 일치하지 않습니다."),
                        ));
                      } else if (signupPasswordController.text == signupConfirmPasswordController.text) {
                        String bLogin = await getRegister(
                            signupIDController.text.trim(),
                            signupPasswordController.text.trim(),
                            signupUserNameController.text.trim(),
                            signupNickNameController.text.trim(),
                            schoolGrade
                        );
                        if(bLogin == "SUCCESS") {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("회원가입이 완료되었습니다."),
                          ));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("이미 존재하는 아이디입니다."),
                          ));
                        }
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("로그인에 실패했습니다. 아이디 또는 비밀번호를 확인해주세요."),
                        ));
                      }
                    }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpL(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String schoolGrade;

    if(school == '초등학교'){
      schoolGrade = 'P'+grade.substring(0,1);
    } else if(school == '중학교'){
      schoolGrade = 'M'+grade.substring(0,1);
    } else {
      schoolGrade = 'H'+grade.substring(0,1);
    }

    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: size.width * 0.71,
                  height: size.height * 0.52,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeName,
                            controller: signupIDController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.04,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.idCard,
                                color: Colors.blueAccent,
                                size: size.height * 0.06,
                              ),
                              hintText: "ID",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.04),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeEmail,
                            controller: signupUserNameController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.04,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.blueAccent,
                                size: size.height * 0.06,
                              ),
                              hintText: "한글 이름",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.04),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNickName,
                            controller: signupNickNameController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.04,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.font,
                                color: Colors.blueAccent,
                                size: size.height * 0.06,
                              ),
                              hintText: "영어 이름",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.04),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.school,
                                color: Colors.blueAccent,
                                size: size.height * 0.05,
                              ),
                              SizedBox(
                                width: size.width * 0.03,
                              ),
                              DropdownButton<String>(
                                value: school,
                                icon: Icon(FontAwesomeIcons.caretDown),
                                iconSize: size.height * 0.04,
                                elevation: 3,
                                style: TextStyle(color: Colors.blueAccent),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String schoolValue) {
                                  setState(() {
                                    school = schoolValue;
                                  });
                                },
                                items: <String>['초등학교', '중학교', '고등학교']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontSize: size.height * 0.04),),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                width: size.width * 0.04,
                              ),
                              DropdownButton<String>(
                                value: grade,
                                icon: Icon(FontAwesomeIcons.caretDown),
                                iconSize: size.height * 0.04,
                                elevation: 3,
                                style: TextStyle(color: Colors.blueAccent),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                onChanged: (String gradeValue) {
                                  setState(() {
                                    grade = gradeValue;
                                  });
                                },
                                items: (school == '초등학교')? <String>['1학년', '2학년', '3학년', '4학년', '5학년', '6학년']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontSize: size.height * 0.04),),
                                  );
                                }).toList() : <String>['1학년', '2학년', '3학년']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: TextStyle(fontSize: size.height * 0.04),),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodePassword,
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.04,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.blueAccent,
                                size: size.height * 0.06,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.04),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  color: Colors.blueAccent,
                                  size: size.height * 0.05,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.63,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: size.height * 0.04,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.blueAccent,
                                size: size.height * 0.06,
                              ),
                              hintText: "Confirmation",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: size.height * 0.04),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextSignupConfirm
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  color: Colors.blueAccent,
                                  size: size.height * 0.05,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.47),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  /*boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.blueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Colors.lightBlueAccent,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                  ],*/
                  gradient: new LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blueAccent
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.06,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed:
                        () async {

                      if (signupIDController.text == '') {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("아이디를 입력해주세요."),
                        ));
                      } else if (signupPasswordController.text == '') {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("비밀번호를 입력해주세요."),
                        ));
                      } else if (signupPasswordController.text != signupConfirmPasswordController.text) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("확인 비밀번호가 일치하지 않습니다."),
                        ));
                      } else if (signupPasswordController.text == signupConfirmPasswordController.text) {
                        String bLogin = await getRegister(
                            signupIDController.text.trim(),
                            signupPasswordController.text.trim(),
                            signupUserNameController.text.trim(),
                            signupNickNameController.text.trim(),
                            schoolGrade
                        );
                        if(bLogin == "SUCCESS") {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("회원가입이 완료되었습니다."),
                          ));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("이미 존재하는 아이디입니다."),
                          ));
                        }
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("로그인에 실패했습니다. 아이디 또는 비밀번호를 확인해주세요."),
                        ));
                      }
                    }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    if(this.mounted) {
      setState(() {
        _obscureTextLogin = !_obscureTextLogin;
      });
    }
  }

  void _toggleSignup() {
    if(this.mounted) {
      setState(() {
        _obscureTextSignup = !_obscureTextSignup;
      });
    }
  }

  void _toggleSignupConfirm() {
    if(this.mounted) {
      setState(() {
        _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
      });
    }
  }

  _loadProfile() async {
    //SharedPreferences 의 인스턴스를 필드에 저장
    _sharedPreferences = await SharedPreferences.getInstance();
    if(this.mounted) {
      setState(() {
        _isChecked = (_sharedPreferences.getBool('isChecked') ?? false);
        if (_isChecked == true) {
          loginEmailController.text =
          (_sharedPreferences.getString('loginID') ?? '');
          loginPasswordController.text =
          (_sharedPreferences.getString('loginPassword') ?? '');
        }
      });
    }
  }

  _saveProfile() async {
    if(this.mounted) {
      //SharedPreferences 에 저장
      setState(() {

        //}
      });
    }
  }

}
