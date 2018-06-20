import 'package:flutter/material.dart';
import 'places.dart';

class SpecialItemsPage extends StatefulWidget {
  final List<Restaurant> list;
  final String title;
  SpecialItemsPage({Key key, this.title, this.list}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _SpecialItemsState();
  }
}

class _SpecialItemsState extends State<SpecialItemsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new GridView.count(
          crossAxisCount: 2,
          children: new List.generate(widget.list.length, (index) {
            return new Center(
              child: new Container(
                decoration: new BoxDecoration(
                  border: new Border.all(width: 10.0, color: getColor()),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(8.0)),
                ),
                margin: const EdgeInsets.all(4.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      widget.list[index].name,
                      style: new TextStyle(fontSize: 20.0, color: getColor()),
                    ),
                    new Text(widget.list[index].address),
                  ],
                ),
              ),
            );
          }),
        ));
  }

  getColor() {
    if ('黑名单' == widget.title) {
      return Colors.black;
    } else {
      return Theme.of(context).primaryColor;
    }
  }
}
