import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkwho/models/learn.dart';
import 'package:talkwho/models/question.dart';
import 'package:talkwho/models/saveList.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/study1_page.dart';
import 'package:talkwho/ui/pages/study2_page.dart';
import 'package:talkwho/ui/widgets/circular_button.dart';
import 'package:talkwho/ui/widgets/gradient_icon.dart';

class SaveListPage extends StatefulWidget {

  const SaveListPage({Key key}) : super(key: key);

  @override
  _SaveListPageState createState() => _SaveListPageState();
}

class _SaveListPageState extends State<SaveListPage> with TickerProviderStateMixin{


  List<SaveList> saveLists = List<SaveList>(999);

  bool _isClicked = false;
  bool _isSaved;

  String _memberSeq = '';

  void _getSaveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String memberSeq = prefs.getString('memberSeq');
    List<SaveList> saveList =  await getSaveList(memberSeq);
    if(saveLists[0]?.vocaKor != null) {
      saveLists = saveList;
    }
    _memberSeq = memberSeq;
    if(this.mounted) {
      setState(() {
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _getSaveList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('저장한 단어'),
        elevation: 0,
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
              tileMode: TileMode.clamp
          ),
        ),
        child: Stack(
          children: <Widget>[
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: saveLists.length,
              itemBuilder: _buildItem,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {

    Size size = MediaQuery.of(context).size;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: size.width * 0.34,
              child: (saveLists[index] != null)? AutoSizeText(HtmlUnescape().convert(saveLists[index]?.vocaEng),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
              minFontSize: 8.0,
              ) : Text(""),
            ),
            SizedBox(width: size.width * 0.04),
            SizedBox(
              width: size.width * 0.34,
              child: (saveLists[index] != null)? AutoSizeText(HtmlUnescape().convert(saveLists[index]?.vocaKor),
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                ),
                minFontSize: 8.0,
                maxLines: 1,
              ) : Text(""),
            ),
            SizedBox(width: size.width * 0.03),
            (saveLists[index] != null)? new GestureDetector(
              onTap: () async{
                setState(() {
                  saveLists[index].isSaved =
                  !saveLists[index].isSaved;
                });
                (saveLists[index].isSaved == true)? _isSaved = await getSavedWord(_memberSeq, saveLists[index].unitSeq, saveLists[index].vocaSeq, saveLists[index].vocaEng, saveLists[index].vocaKor):
                    _isSaved = await getDeleteWord(_memberSeq, saveLists[index].vocaSeq);
              },
              child: new AnimatedOpacity(
                opacity: (saveLists[index].isSaved == false)?0.6:1.0,
                duration: Duration(milliseconds: 500),
                child: new GradientIcon(
                  icon: (saveLists[index].isSaved == false)?FontAwesomeIcons.star : FontAwesomeIcons.solidStar,
                  size: size.width * 0.06,
                  gradient: new LinearGradient(
                    colors: [
                      Colors.yellow,
                      Colors.orange
                    ],
                  ),
                ),
                curve: Curves.fastOutSlowIn,
              ),
            /*IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: GradientIcon(
                icon: (_isSaved == false)?FontAwesomeIcons.star : FontAwesomeIcons.solidStar,
                size: size.width * 0.06,
                gradient: new LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.orange
                  ],
                ),
              ),
              onPressed: (){
                (_isSaved == false)?_isSaved = true : _isSaved = false;
              },
            )*/
            ) : Text(''),
          ],
        ),
      ),
    );
  }
}