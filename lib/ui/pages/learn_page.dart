import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/ui/pages/sen2_page.dart';
import 'package:talkwho/ui/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/models/learn.dart';


import 'package:talkwho/models/question.dart';
import 'package:talkwho/ui/pages/error.dart';
import 'package:talkwho/ui/pages/quiz_page.dart';
import 'package:talkwho/ui/pages/study1_page.dart';
import 'package:talkwho/ui/pages/study2_page.dart';

import 'package:talkwho/ui/pages/sen1_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearnPage extends StatefulWidget {
  final Unit unit;
  const LearnPage({Key key, this.unit}) : super(key: key);

  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {

  List<Learn> learns = List();
  bool processing;

  void _getLearn() async {
    List<Learn> learn =  await getLearn(widget.unit);
    if(this.mounted) {
      setState(() {
        learns = learn;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("unit", widget.unit.unitSeq.toString());
    //print(widget.unit);
  }

  @override
  void initState() {
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context){

    _getLearn();

    return Scaffold(
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
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                  child: Text("학습메뉴", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context, index) => Card(
                            child:ListTile(
                              leading:CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: Text("${index+1}"),
                              ),
                              trailing: Icon(Icons.navigate_next),
                              title: Text(learns[index].title),
                              subtitle: Text(learns[index].subtitle),
                                onTap: () { _study1(learns[index]); }
                          ),
                        ),
                    childCount: learns.length),
              ),
            ],
          ),
        ],
      )
    );
  }

  void _study1(Learn learn) async {
    if(this.mounted) {
      setState(() {
        processing = true;
      });
    }
    try {
      List<Question> questions =  await getQuestions(widget.unit, learn.type, learn.code);
      //Navigator.pop(context);
      if(questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(message: "There are not enough questions in the category, with the options you selected.",)
        ));
        return;
      }
      //FlashCard
      if(learn.code == "101") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Study1Page(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }
      //K->E
      if(learn.code == "102") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Study2Page(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }
      //E->K
      if(learn.code == "103") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Study2Page(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }
      //Writing
      if(learn.code == "104") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Sen1Page(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }

      //Listening Test
      if(learn.code == "207") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => QuizPage(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }

      //FlashCard
      if(learn.code == "201") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Study1Page(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }
      //k-E
      if(learn.code == "202") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Study2Page(questions: questions, unit: widget.unit)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }
      //k-E
      if(learn.code == "203") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Study2Page(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }


      //Wirting
      if(learn.code == "204") {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => Sen2Page(questions: questions, unit: widget.unit,)
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("code", learn.code.toString());
        print(learn.code);
      }

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
        processing = false;
      });
    }
  }

  void _startQuiz() async {
    if(this.mounted) {
      setState(() {
        processing = true;
      });
    }
    try {
      List<Question> questions =  await getQuestions(widget.unit, 'test', '207');
      Navigator.pop(context);
      if(questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(message: "There are not enough questions in the category, with the options you selected.",)
        ));
        return;
      }
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(questions: questions, unit: widget.unit,)
      ));
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
        processing = false;
      });
    }
  }
}