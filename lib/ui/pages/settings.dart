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

  void getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String loginUserName = prefs.getString('loginUserName');
    String loginNickName = prefs.getString('loginNickName');
    if(this.mounted) {
      setState(() {
        _loginUserName = loginUserName;
        _loginNickName = loginNickName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserInfo();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Theme(
        data: Theme.of(context).copyWith(
          brightness: Brightness.dark,
          primaryColor: Colors.purple,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
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
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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