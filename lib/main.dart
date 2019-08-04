import 'package:briefing/briefing_sliver_list.dart';
import 'package:briefing/model/database/database.dart';
import 'package:briefing/theme/theme.dart';
import 'package:briefing/widget/main_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Briefing',
      theme: buildAppTheme(),
      home: MyHomePage(title: 'Briefing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static var briefingSliver = BriefingSliverList();
  var _pages = {
    "Briefing": briefingSliver,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    DBProvider.db.close();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarDividerColor: Colors.grey,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: CustomScrollView(
            slivers: <Widget>[
              MainSliverAppBar(title: _pages.keys.elementAt(_selectedIndex)),
              _pages.values.elementAt(_selectedIndex)
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.grey[50],
            child: InkWell(
              onTap: () => showBottomAppBarSheet(),
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => showBottomAppBarSheet()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  void showBottomAppBarSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Colors.transparent,
          child: Container(
            height: 140.0,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Wrap(children: <Widget>[
              ListTile(
                leading: Icon(Icons.format_list_bulleted),
                title: Text('Headlines'),
                onTap: () {
                  _onItemTapped(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('Newsstands'),
                onTap: () {
                  _onItemTapped(1);
                },
              ),
            ]),
          ),
        );
      },
    );
  }
}
