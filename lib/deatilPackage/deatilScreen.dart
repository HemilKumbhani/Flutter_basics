import 'package:flutter/material.dart';
import 'package:web_view_app/model/MoviesModel.dart';

class DetailScreen extends StatefulWidget {
  MoviesModel movieDetail;

  DetailScreen(this.movieDetail);

  @override
  State<StatefulWidget> createState() {
    print(movieDetail.toString());
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
          title: Text(widget.movieDetail.title),
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
                              "https://image.tmdb.org/t/p/w500/" +
                                  widget.movieDetail.backdropPath),
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
                              "https://image.tmdb.org/t/p/w500/" +
                                  widget.movieDetail.posterPath),
                          fit: BoxFit.contain)),
                ),
                alignment: AlignmentDirectional.centerStart,
              ),
              Align(
                child: new Container(
                  width: 200,
                    margin: EdgeInsets.fromLTRB(150,100,0,0),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: new Text(widget.movieDetail.title),
                          margin: EdgeInsets.only(top: 20),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width:200,
                              height: 100,
                              margin: EdgeInsets.only(top: 10),
                              child: SingleChildScrollView(child: new Text(widget.movieDetail.overview)),
                            ),
                          ],
                        )
                      ],
                    )),
                alignment: AlignmentDirectional.center,
              ),
              Positioned(
                child: Container(
                  width: 400,
//                  decoration: BoxDecoration(color: Colors.blue),
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
