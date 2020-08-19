import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/ui/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talkwho/resources/api_provider.dart';
import 'package:talkwho/models/book.dart';
import 'learn_page.dart';

class UnitPage extends StatefulWidget {
  final Book book;
  const UnitPage({Key key, this.book}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UnitPage> {

  List<Unit> units = List();

  void _getUnit() async {
    List<Unit> unit =  await getUnit(widget.book.bookSeq);

    setState(() {
      units = unit;
    });

  }

  @override
  Widget build(BuildContext context){

    _getUnit();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.bookName),
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
                  child: Text("학습차시", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0
                  ),
                  delegate: SliverChildBuilderDelegate(
                    _buildCategoryItem,
                    childCount: units.length,

                  )

                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {

    Unit unit = units[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, unit),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

            SizedBox(height: 5.0),
          AutoSizeText(
            unit.unitName,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context,Unit unit) {

    if(unit.category == "listening" && unit.score == null) {
      showModalBottomSheet(
        context: context,
        builder: (sheetContext) =>
            BottomSheet(
              builder: (_) => QuizOptionsDialog(unit: unit,),
              onClosing: () {},

            ),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => LearnPage(unit: unit,)
      ));
    }
  }
}