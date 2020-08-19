import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talkwho/models/category.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/ui/pages/home.dart';
import 'package:talkwho/widgets/auto_refresh.dart';
import 'package:talkwho/widgets/empty_card.dart';
import 'category2.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CategoryPage> {

  List<Category> categories = List(999);

  void _getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String schoolGrade = prefs.getString('schoolGrade');
    List<Category> category =  await getCategory("1", schoolGrade);
    if(this.mounted) {
      setState(() {
        categories = category;
      });
    }
  }

  @override
  Widget build(BuildContext context){

    _getCategory();
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => HomePage()
        ),);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.home, color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => HomePage()
              ));
            },
          ),
          title: Text('카테고리를 지정해주세요'),
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
                tileMode: TileMode.clamp),
          ),
          child: SafeArea(
            child: AnimationLimiter(
              child: GridView.count(
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 3,
                children: List.generate(
                  categories.length, (index) {
                    return AnimationConfiguration.staggeredGrid(
                      columnCount: 3,
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: ScaleAnimation(
                        scale: 0.5,
                        child: FadeInAnimation(
                            child: _buildCategoryItem(context, index)
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {

    Category category = categories[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: new MaterialButton(
        elevation: 1.0,
        highlightElevation: 1.0,
        onPressed: () => _categoryPressed(context, category),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        textColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              category?.title == null ? '' : category.title,
              minFontSize: 10.0,
              textAlign: TextAlign.center,
              maxLines: 3,
              wrapWords: false,),
          ],
        ),
      ),
    );
  }
  _categoryPressed(BuildContext context,Category cate) {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => Category2Page( category: cate,)
    ));
  }
}