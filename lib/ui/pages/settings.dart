import 'package:flutter/material.dart';
import 'package:talkwho/models/profile.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/ui/pages/login_page.dart';
import 'package:talkwho/models/login.dart';
import 'package:talkwho/ui/pages/main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SettingsPage> {

  SharedPreferences _sharedPreferences;
  List<Profile> profiles = List();

  final TextStyle whiteText = TextStyle(
    color: Colors.white,
  );

  final TextStyle greyTExt = TextStyle(
    color: Colors.grey.shade400,
  );

  String _loginUserName;
  String _loginNickName;
  String _studentImage = '';

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String loginUserName = prefs.getString('loginUserName');
    String loginNickName = prefs.getString('loginNickName');
    String studentImage = prefs.getString('studentImage');
    if(this.mounted) {
      setState(() {
        _loginUserName = loginUserName;
        _loginNickName = loginNickName;
        _studentImage = studentImage;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(size.width * 0.08),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.07),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Colors.lightBlueAccent
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.circular(size.width * 0.05),
                  ),
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.width * 0.17,
                        height: size.width * 0.17,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: (_studentImage == "http://talkwho.whitesoft.net/") ?
                            NetworkImage('http://talkwho.whitesoft.net/data/profile/c1c709c9e534e58312c6c10ed9fccc28.png')
                                : NetworkImage(_studentImage),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_loginUserName.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              _loginNickName.toString(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                ListTile(
                  title: Text(
                    "Languages",
                  ),
                  subtitle: Text(
                    "English US",
                    style: greyTExt,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey.shade400,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    "Profile Settings",
                    style: greyTExt,
                  ),
                  subtitle: Text(
                    "Jane Doe",
                    style: greyTExt,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey.shade400,
                  ),
                  onTap: () {},
                ),
                SwitchListTile(
                  title: Text(
                    "Email Notifications",
                    style: greyTExt,
                  ),
                  subtitle: Text(
                    "On",
                    style: greyTExt,
                  ),
                  value: true,
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  title: Text(
                    "Push Notifications",
                    style: greyTExt,
                  ),
                  subtitle: Text(
                    "Off",
                    style: greyTExt,
                  ),
                  value: false,
                  onChanged: (val) {},
                ),
                ListTile(
                  title: Text(
                    "Logout",
                    style: greyTExt,
                  ),
                  onTap: () async {await _logout();},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _logout() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    if(this.mounted) {
      setState(() {
        _sharedPreferences.setString('loginID', '');
        _sharedPreferences.setString('loginPassword', '');
        _sharedPreferences.setString('loginUserName', '');
        _sharedPreferences.setString('loginNickName', '');
        //print(_loginUserName);
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage(),),);
      });
    }
  }
}