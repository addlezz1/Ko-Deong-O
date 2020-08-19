import 'package:flutter/material.dart';
import 'package:talkwho/ui/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/ui/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SharedPreferences _sharedPreferences;
  String _loginUserID = '';

  @override
  void initstate(){
    super.initState();
    _getLoginID();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open Trivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pink,
        fontFamily: "Montserrat",
        buttonColor: Colors.indigo,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary
        )
      ),

      home: (_loginUserID != '')? HomePage() : LoginPage(),
    );
  }

  void _getLoginID() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String loginUserID = _sharedPreferences.getString('loginID');
    //Return String
    if (this.mounted) {
      setState(() {
        _loginUserID = loginUserID;
      });
    }
  }
}
