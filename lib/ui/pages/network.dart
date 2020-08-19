//import 'package:soundwave/music/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  static final String sUrl = "http://eduby.whitesoft.net/api/service/home";
  static final String baseUrl = "http://funk-music.herokuapp.com/";



  static final String searchUrl = baseUrl + "search/";
  static Future getHome() async {
    var response = await http.get(sUrl);
    var data = jsonParse(response.body);

    return data;
  }

  static Map<String, List> jsonParse(body) {
    Map<String, List> items = Map<String, List>();
    Map<dynamic, dynamic> map = json.decode(body);
    map.forEach((key, value) {
      String title = key;
      print(title);
      items.putIfAbsent(title, () => []);
      value.forEach((jsonItem) {
        String type = jsonItem["type"];
        var item;
        try {

        } catch (e) {
          print(e);
        }
        if (item != null) {
          items[title].add(item);
        }
      });
    });

    return items;
  }



  static Future searchTag(String tag, {int page = 1}) async {
    var response = await http.get(searchUrl + "$tag" + "/" + "$page");

    return jsonParse(response.body);
  }


}
