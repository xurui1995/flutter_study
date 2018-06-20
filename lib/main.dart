import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'places.dart';
import 'ItemDetailPage.dart';
import 'SpecialItemsPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer';
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  // debugPaintSizeEnabled = true;
  print("main() start");
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter学习',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: '附近的美食'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Restaurant> _restaurants = <Restaurant>[];

  List<Restaurant> _goodRestaurants = <Restaurant>[];
  List<Restaurant> _badRestaurants = <Restaurant>[];

  var phone = '';
  static const CHANNEL_PACKAGE =
      const MethodChannel('xur.flutter.io/first_flutter');

  Future<Null> _getPhoneMsg() async {
    try {
      phone = await CHANNEL_PACKAGE.invokeMethod('getPhoneMsg');
      print(phone.toString());
      setState(() {});
    } on PlatformException catch (e) {
      print("failed ");
    }
  }

  Future<Null> _startSecondActivity() async {
    try {
      await CHANNEL_PACKAGE.invokeMethod('startSecondActivity');
    } on PlatformException catch (e) {
      print("failed ");
    }
  }

  @override
  void initState() {
    super.initState();
    // _places = new List.generate(100, (i)=>'Restaurant $i');
    _getPhoneMsg();
    listenForPlaces();
  }

  void listenForPlaces() async {
    var stream = await getPlaces();
    stream.listen((restaurant) => setState(() => _restaurants.add(restaurant)));
  }

  Future<Null> _handleRefresh() async {
    // 模拟刷新数据
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          leading: new Icon(Icons.fastfood),
        ),
        body: new Builder(builder: (BuildContext context) {
          return new Center(
              child: new RefreshIndicator(
                  child: new ListView(
                      children: _restaurants
                          .map((restaurant) => new Dismissible(
                              key: new Key(restaurant.name),
                              onDismissed: (direction) {
                                _restaurants.remove(restaurant);
                                if (direction == DismissDirection.startToEnd) {
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(content: new Text("好吃！！！")));
                                  _addSpList('nice_food_list', restaurant.name);

                                  if (!_goodRestaurants.contains(restaurant)) {
                                    _goodRestaurants.add(restaurant);
                                  }
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(
                                          content: new Text("难吃！！拉黑！")));
                                  _addSpList('black_list', restaurant.name);

                                  if (!_badRestaurants.contains(restaurant)) {
                                    _badRestaurants.add(restaurant);
                                  }
                                }
                              },
                              background: new Container(
                                color: Colors.green,
                              ),
                              secondaryBackground:
                                  new Container(color: Colors.red),
                              child: new ListTile(
                                  title: new Text(restaurant.name),
                                  subtitle: new Text(restaurant.address),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (context) {
                                          return new ItemDetailPage(
                                              title: restaurant.name);
                                        },
                                      ),
                                    );
                                  },
                                  leading: new CircleAvatar(
                                      child: new Text(
                                          restaurant.rating.toString()),
                                      backgroundColor:
                                          getColor(restaurant.rating)))))
                          .toList()),
                  onRefresh: _handleRefresh));
        }),
        endDrawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(phone),
                accountEmail: new Text('example@2345.com'),
                currentAccountPicture: new GestureDetector(
                  onTap: () => print('current user'),
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(
                        'https://gss3.bdstatic.com/84oSdTum2Q5BphGlnYG/timg?wapp&quality=80&size=b150_150&subsize=20480&cut_x=0&cut_w=0&cut_y=0&cut_h=0&sec=1369815402&srctrace&di=8365c159f3eda8bc5ceecae0530ed11b&wh_rate=null&src=http%3A%2F%2Ftb1.bdstatic.com%2Ftb%2Fr%2Fimage%2F2014-01-26%2F1f250f8e5f9c0ba0d83f2cf443903ee0.jpg'), //图片调取自网络
                  ),
                ),
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new ExactAssetImage('images/lake.jpg'),
                  ),
                ),
              ),
              new ListTile(
                  leading: new Icon(
                    Icons.thumb_down,
                    color: Colors.blue[500],
                  ),
                  title: new Text('黑名单'),
                  trailing: new Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (context) {
                          print(_badRestaurants);
                          return new SpecialItemsPage(
                              title: '黑名单', list: _badRestaurants);
                        },
                      ),
                    );
                  }),
              new ListTile(
                  leading: new Icon(
                    Icons.favorite,
                    color: Colors.blue[500],
                  ),
                  title: new Text('好吃的店'),
                  trailing: new Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (context) {
                          print(_badRestaurants);
                          return new SpecialItemsPage(
                              title: '好吃的店', list: _goodRestaurants);
                        },
                      ),
                    );
                  }),
              new Divider(),
              new ListTile(
                  leading: new Icon(
                    Icons.exit_to_app,
                    color: Colors.blue[500],
                  ),
                  title: new Text('安全退出'),
                  trailing: new Icon(Icons.cancel),
                  onTap: () {
                    //退出
                    exit(0);
                  }),
            ],
          ),
        ),
        floatingActionButton: new Builder(builder: (BuildContext context) {
          return new FloatingActionButton(
            onPressed: () {
              Scaffold
                  .of(context)
                  .showSnackBar(new SnackBar(content: new Text("我没有任何功能")));
            },
            child: new Icon(Icons.add),
          );
        }));
  }

  Color getColor(double rating) {
    return Color.lerp(Colors.red, Colors.green, rating / 5);
  }

  _getSpList(String spKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(spKey);
    return list;
  }

  // Sp的使用
  void _addSpList(String spKey, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList(spKey);
    if (list == null) {
      list = new List();
    }
    print(list);
    if (!list.contains(value)) {
      list.add(value);
      prefs.setStringList(spKey, list);
    }
  }
}
