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
  final String bookValue;
  const CategoryPage({Key key, this.bookValue}) : super(key: key);
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
    //print(schoolGrade);
    if(this.mounted) {
      setState(() {
        categories = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Form(
        child: (orientation == Orientation.portrait)
            ? portraitMode(context)
            : landscapeMode(context),
      ),
    );
  }

  Widget portraitMode(context){
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
              Icons.home, color: Colors.white, size: size.height * 0.03,
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
                crossAxisCount: 4,
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

  Widget landscapeMode(context){

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
              Icons.home, color: Colors.white, size: size.width * 0.03,
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
                crossAxisCount: 6,
                children: List.generate(
                  categories.length, (index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 3,
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: FadeInAnimation(
                          child: _buildCategoryItemL(context, index)
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

    Size size = MediaQuery.of(context).size;

    Category category = categories[index];
    return Column(
      children: <Widget>[
        Container(
          height: size.width * 0.2,
          width: size.width * 0.2,
          padding: EdgeInsets.symmetric(vertical: size.width * 0.02, horizontal: size.width * 0.02),
          child: new MaterialButton(
            elevation: 3.0,
            highlightElevation: 1.0,
            onPressed: () => _categoryPressed(context, category),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * 0.03),
            ),
            color: Colors.white,
            textColor: Colors.blue,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Opacity(
                  opacity: 0.7,
                  child: (category?.schoolGrade == 'H1') ? Image.asset('assets/images/H1.png') :
                  (category?.schoolGrade == 'H2') ? Image.asset('assets/images/H2.png') :
                  (category?.schoolGrade == 'H3') ? Image.asset('assets/images/H3.png') :
                  SizedBox(),
                ),
              ],
            ),
          ),
        ),
        Text(
          (category?.title == null) ? '' : category.title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent, fontSize: size.height * 0.015),
        ),
      ],
    );
  }

  Widget _buildCategoryItemL(BuildContext context, int index) {

    Size size = MediaQuery.of(context).size;

    Category category = categories[index];
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.2,
          width: size.height * 0.2,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.height * 0.02),
          child: new MaterialButton(
            elevation: 3.0,
            highlightElevation: 1.0,
            onPressed: () => _categoryPressed(context, category),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.height * 0.03),
            ),
            color: Colors.white,
            textColor: Colors.blue,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Opacity(
                  opacity: 0.7,
                  child: (category?.schoolGrade == 'H1') ? Image.asset('assets/images/H1.png') :
                  (category?.schoolGrade == 'H2') ? Image.asset('assets/images/H2.png') :
                  (category?.schoolGrade == 'H3') ? Image.asset('assets/images/H3.png') :
                  SizedBox(),
                ),
              ],
            ),
          ),
        ),
        Text(
          (category?.title == null) ? '' : category.title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.redAccent, fontSize: size.width * 0.015),
        ),
      ],
    );
  }

  _categoryPressed(BuildContext context,Category cate) {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => Category2Page( category: cate, bookValue: widget.bookValue,)

    ));
  }
}