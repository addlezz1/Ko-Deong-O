import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:talkwho/models/currentLearn.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/current_learning.dart';
import 'package:talkwho/ui/pages/currents.dart';
import 'package:talkwho/ui/pages/login_page.dart';
import 'package:talkwho/ui/pages/quiz_page.dart';
import 'package:talkwho/ui/pages/settings.dart';
import 'category.dart';
import 'main.dart';
import 'unit.dart';
import 'video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {


  const HomePage({Key key}) : super(key: key);
  //HomePage({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

PageController pageController;

class _HomePageState extends State<HomePage> {
  int _page = 0;
  bool triedSilentLogin = false;
  bool setupNotifications = false;
  bool isLogin = true;

  SharedPreferences _sharedPreferences;

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('종료하시겠습니까?'),
        content: Text('저장되지 않은 진행상황이 지워집니다!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => exit(0),
            /*Navigator.of(context).pop(true)*/
            child: Text('네'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('아니요'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    if (triedSilentLogin == false) {
      // silentLogin(context);
    }

    //if (setupNotifications == false && currentUserModel != null) {
    //setUpNotifications();
    //}
    //AuthBlock auth = Provider.of<AuthBlock>(context);
    //if (auth.isLoggedIn)
    //print(auth.isLoggedIn);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          children: [
            Container(color: Colors.white, child: MainPage()),
            Container(color: Colors.white, child: CategoryPage()),
            Container(color: Colors.white, child: CurrentsPage(),),
            Container(color: Colors.white, child: ChewieDemo()),
            Container(color: Colors.white, child: SettingsPage()),
          ],
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: (_page == 0) ? Colors.black : Colors.white),
                title: Container(height: 0.0),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu,
                    color: (_page == 1) ? Colors.black : Colors.white),
                title: Container(height: 0.0),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.school,
                    color: (_page == 2) ? Colors.black : Colors.white),
                title: Container(height: 0.0),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: (_page == 3) ? Colors.black : Colors.white),
                title: Container(height: 0.0),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings,
                    color: (_page == 4) ? Colors.black : Colors.white),
                title: Container(height: 0.0),
                backgroundColor: Colors.white),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }


  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    if(this.mounted) {
      setState(() {
        this._page = page;
      });
    }
  }

  void _loadProfile() async {
    //SharedPreferences 의 인스턴스를 필드에 저장
    _sharedPreferences = await SharedPreferences.getInstance();
    var loginID = _sharedPreferences.getString('loginEmail');
    var password = _sharedPreferences.getString('loginPassword');
    //print('----------------------');
    //print(loginID);
    //print(password);
    /*if((loginID == '' && password == '')||(loginID == null && password == null)){
      isLogin = false;
      if (isLogin == false){
        //print(isLogin);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),),);
      }
    }*/
  }

  @override
  void initState() {
    _loadProfile();
    pageController = PageController();
    super.initState();
  }

  /*@override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }*/
}

