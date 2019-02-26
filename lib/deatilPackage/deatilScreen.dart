import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _detailScreen();
  }
}

class _detailScreen extends State<DetailScreen> {
  List<String> producersList = new List();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: AppBar(
          title: Text("MovieDetail"),
        ),
        body: new Container(
          constraints: BoxConstraints.expand(),
          color: Colors.transparent,
          child: new Stack(
            children: <Widget>[
              Align(
                child: new Container(
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://coloredbrain.com/wp-content/uploads/2016/07/login-background.jpg'),
                          fit: BoxFit.cover)),
                ),
                alignment: AlignmentDirectional.topCenter,
              ),
              Align(
                child: new Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://coloredbrain.com/wp-content/uploads/2016/07/login-background.jpg'),
                          fit: BoxFit.cover)),
                ),
                alignment: AlignmentDirectional.centerStart,
              ),
              Align(
                child: new Container(
                    margin: EdgeInsets.only(top: 30),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: new Text("Name"),
                          margin: EdgeInsets.only(top: 10),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: new Text("Genre"),
                        )
                      ],
                    )),
                alignment: AlignmentDirectional.center,
              ),
              Positioned(
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: _ListMakers(),
                  height: 100,
                ),
                bottom: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ListMakers() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: 50,
        itemBuilder: (context, i) {
          producersList.add("India" + i.toString());
          return Widget_buidColumn(producersList[i]);
        });
  }

  Widget_buidColumn(String text) {
    return new Container(
        // color: Colors.blue,
        padding: const EdgeInsets.all(10.0),
        child: new Row(children: [new Text(text)]));
  }
}
