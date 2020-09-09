import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:talkwho/models/category.dart';
import 'package:talkwho/models/login.dart';
import 'package:talkwho/models/profile.dart';
import 'package:talkwho/models/question.dart';
import 'package:talkwho/models/book.dart';
import 'package:talkwho/models/register.dart';
import 'package:talkwho/models/saveList.dart';
import 'package:talkwho/models/testResult.dart';
import 'package:talkwho/models/testScore.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/models/learn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talkwho/models/currentLearn.dart';

const String baseUrl = "http://talkwho.whitesoft.net";

Future<List<Book>> getHomeBook(String unit_seq) async {
  String url = "$baseUrl/api/main/progress";
  //String url = "http://eduby.whitesoft.net/api/main/progress";

  Map<String,String> _params = {};
  //_params['class_seq'] = "1";
  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> books = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);
  return Book.fromData(books);
}

Future<List<Category>> getCategory(String seq, String schoolGrade) async {
    String url = "$baseUrl/api/main/category";

    Map<String,String> _params = {};
    _params['cate_seq'] = seq;
    _params['school_grade'] = schoolGrade;
    final response = await http.post(url, body:_params);
    //print(response.body);

  List<Map<String, dynamic>> categories = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);
  return Category.fromData(categories);
}

Future<List<Book>> getBook(String cate_seq,String bookValue) async {
  String url = "$baseUrl/api/main/book";
  //String url = "http://eduby.whitesoft.net/api/main/progress";

  Map<String,String> _params = {};
  _params['cate_seq'] = cate_seq;
  _params['book_value'] = bookValue;
  //print(_params);
  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> books = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);
  return Book.fromData(books);
}

Future<List<Unit>> getUnit(String book_seq) async {
  //String url = "$baseUrl?amount=$total&category=${category.id}";
  String url = "$baseUrl/api/main/unitlist";

  Map<String,String> _params = {};
  _params['book_seq'] = book_seq;
  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> units = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);

  return Unit.fromData(units);

}

Future<List<Learn>> getLearn(Unit unit) async {
    String url = "$baseUrl/api/player";

  Map<String,String> _params = {};
    _params['type'] = unit.category;
    _params['unit_seq'] = unit.unitSeq;
    _params['code'] = "000";
  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> learns = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);

  return Learn.fromData(learns);
}

Future<List<Question>> getQuestions(Unit unit, String type, String code) async {
  //String url = "$baseUrl?amount=$total&category=${category.id}";
  String url = "$baseUrl/api/player";

  Map<String,String> _params = {};
  _params['type'] = type;
  _params['unit_seq'] = unit.unitSeq;
  _params['code'] = code;
  //print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> questions = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);
  return Question.fromData(questions);
}

Future<List<Question>> getVocaQuestions(Unit unit, String type, String code, String memberSeq) async {
  //String url = "$baseUrl?amount=$total&category=${category.id}";
  String url = "$baseUrl/api/player";

  Map<String,String> _params = {};
  _params['type'] = type;
  _params['unit_seq'] = unit.unitSeq;
  _params['code'] = code;
  _params['member_seq'] = memberSeq;
  //print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> questions = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);
  return Question.fromData(questions);
}

Future<Profile> getProfile(String memberSeq, String campusSeq, String userID,
    String userName, String classSeq, String nickName) async {
  //String url = "$baseUrl?amount=$total&category=${category.id}";
  String url = "$baseUrl/api/auth/login";


  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  _params['campus_seq'] = campusSeq;
  _params['userid'] = userID;
  _params['user_name'] = userName;
  _params['class_seq'] = classSeq;
  _params['nick_name'] = nickName;
  //print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  return Profile.fromMap(json.decode(response.body)["result"]);
}

//비동기인 경우에는 async, await 으로 싱크를 맞춰줘야 함 PHP -> Flutter
Future<Profile> getLogin(String userID, String password) async {
  String url = "$baseUrl/api/auth/login";

  //앱에서 서버로 전송
  Map<String,String> _params = {};
  _params['userid'] = userID;
  _params['password'] = password;
  //print(_params);

  final response = await http.post(url, body:_params);
  print(response.body);
  //String msg = "";
  //var status = json.decode(response.body)['status'];

  //result 값을 서버에서 받음
  return Profile.fromMap(json.decode(response.body)["result"]);
}

//비동기인 경우에는 async, await 으로 싱크를 맞춰줘야 함 PHP -> Flutter
Future<String> getRegister(String userID, String password, String userName, String nickName, String schoolGrade) async {
  String url = "$baseUrl/api/member/check_userid";
  String url2 = "$baseUrl/api/member/signup";

  Map<String,String> _params = {};
  _params['userid'] = userID;
  _params['password'] = password;
  _params['user_name'] = userName;
  _params['nick_name'] = nickName;
  _params['school_grade'] = schoolGrade;
  print(_params);

  bool success;
  final response = await http.post(url, body: _params);
  var status = json.decode(response.body)['status'];
  print(response.body);
  //print(json.decode(response.body)['status']);
  success = false;
  if(status == 'SUCCESS') {
    final response2 = await http.post(url2, body: _params);
    var status2 = json.decode(response2.body)['status'];
    if(status2 == 'SUCCESS') {
      success = true;
    }
  }
  //print(response.body);
  //String msg = "";

  //var message = json.decode(response.body)['message'];

  //return Login.fromMap(json.decode(response.body)["result"]);

  return status;
}

Future<bool> getTestResult(String memberSeq, String classSeq, String unitSeq,
    String testCode, String seq, String answer, String word) async {
  String url = "$baseUrl/api/player/testResult";

  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  _params['class_seq'] = classSeq;
  _params['unit_seq'] = unitSeq;
  _params['test_code'] = testCode;
  _params['seq'] = seq;
  _params['answer'] = answer;
  _params['word'] = word;
  print(_params);

  final response = await http.post(url, body:_params);
  print(response.body);

  return true;
}

Future<CurrentLearn> getCurrentLearn(String memberSeq, String unitSeq, String bookSeq, String bookIndex, String categoryName, String bookName) async {
  String url = "$baseUrl/api/player/currentLearn";

  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  _params['unit_seq'] = unitSeq;
  _params['book_seq'] = bookSeq;
  _params['book_index'] = bookIndex;
  _params['category_name'] = categoryName;
  _params['book_name'] = bookName;
  print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  return CurrentLearn.fromMap(json.decode(response.body)["result"]);
}

Future<CurrentLearn> getCurrentUnit(String memberSeq) async {
  String url = "$baseUrl/api/player/current";

  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  //print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  return CurrentLearn.fromMap(json.decode(response.body)["result"]);
}

Future<List<TestScore>> getTestScore(String memberSeq) async {
  //String url = "$baseUrl?amount=$total&category=${category.id}";
  String url = "$baseUrl/api/player/test_score";

  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> testScores = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);

  return TestScore.fromData(testScores);

}

Future<bool> getSavedWord(String memberSeq, String unitSeq, String vocaSeq,
    String vocaEng, String vocaKor) async {
  String url = "$baseUrl/api/player/save_word";

  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  _params['unit_seq'] = unitSeq;
  _params['voca_seq'] = vocaSeq;
  _params['voca_eng'] = vocaEng;
  _params['voca_kor'] = vocaKor;
  //print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  return true;
}

Future<bool> getDeleteWord(String memberSeq, String vocaSeq) async {
  String url = "$baseUrl/api/player/delete_word";

  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  _params['voca_seq'] = vocaSeq;
  //print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  return true;
}

Future<List<SaveList>> getSaveList(String memberSeq) async {
  //String url = "$baseUrl?amount=$total&category=${category.id}";
  String url = "$baseUrl/api/player/save_list";

  Map<String,String> _params = {};
  _params['member_seq'] = memberSeq;
  //print(_params);

  final response = await http.post(url, body:_params);
  //print(response.body);

  List<Map<String, dynamic>> saveLists = List<Map<String,dynamic>>.from(json.decode(response.body)["results"]);
  return SaveList.fromData(saveLists);
}