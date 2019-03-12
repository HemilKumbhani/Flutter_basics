import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_view_app/deatilPackage/WebSerivceCaller.dart';
import 'package:web_view_app/model/MoviesModel.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class DetailScreen extends StatefulWidget {
  MoviesModel movieDetail;
  int index;
  String movieTypeTitle;

  DetailScreen(this.movieDetail, int index, String movieTypeTitle) {
    this.index = index;
    this.movieTypeTitle = movieTypeTitle;
  }

  @override
  State<StatefulWidget> createState() {
    print(movieDetail.toString());
    return _detailScreen(index, movieDetail);
  }
}

class _detailScreen extends State<DetailScreen> {
  List<String> posterList = new List();
  int index;

  _detailScreen(int index, MoviesModel movieDetail) {
    this.index = index;
    posterList.add(movieDetail.posterPath);
    posterList.add(movieDetail.backdropPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.movieDetail.title),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                child: Stack(
                  children: <Widget>[
                    Align(
                      child: GestureDetector(
                        onTap: () {

                          buildPlayYoutubeVideoById();
                        },
                        child: new Container(
                          height: 250,
                          child: Swiper(
                              itemCount: posterList.length,
                              autoplay: true,
                              scale: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: "https://image.tmdb.org/t/p/w500/" +
                                      posterList[index],
                                  fit: BoxFit.cover,
                                );
                              }),
                        ),
                      ),
                      alignment: AlignmentDirectional.topCenter,
                    ),
                    Positioned(
                      left: 10,
                      bottom: 70,
                      child: Hero(
                        tag: widget.movieDetail.title +
                            "thumb" +
                            widget.movieTypeTitle,
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
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 0,
                      child: new Container(
                        width: 200,
                        margin: EdgeInsets.fromLTRB(150, 100, 0, 0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.movieDetail.title,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic),
                              ),
                              margin: EdgeInsets.only(top: 20),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  height: 100,
                                  margin: EdgeInsets.only(top: 10),
                                  child: SingleChildScrollView(
                                      child: new Text(
                                          widget.movieDetail.overview)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: createSimilarMovieListView(widget.movieDetail.id),
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

 void buildPlayYoutubeVideoById() {
    FlutterYoutube.playYoutubeVideoById(
        apiKey: "AIzaSyBT_9O01_cgjAvjpWa2TDg-75F8AW5JbLA",
        videoId: "hs3eeBTbmoc",
        autoPlay: true, //default falase
        fullScreen: false //default false
        );
  }

  Widget createSimilarMovieListView(int movie_id) {
    return new FutureBuilder(
        future: getSimilarMovie(movie_id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return new Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          if (snapshot.hasData) {
            List movies = snapshot.data;
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text("Similar Movie"),
                      margin: EdgeInsets.all(10),
                    ),
                  ],
                ),
                Container(
                  height: 150,
                  child: new ListView.builder(
                    itemCount: movies.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, position) {
                      MoviesModel movie = movies[position];
                      return movieItem(
                          movie, widget.movieTypeTitle, context, position);
                    },
                  ),
                ),
              ],
            );
          }
        });
  }

/*
  Widget _ListMakers() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: 50,
        itemBuilder: (context, position) {
          return movieItem(movie, movieTypeTitle, context, position);
        });
  }*/

  Hero movieItem(MoviesModel movie, String movieTypeTitle, BuildContext context,
      int position) {
    return Hero(
        tag: movie.title + "thumb" + movieTypeTitle,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        DetailScreen(movie, position, movieTypeTitle),
                    fullscreenDialog: true));
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 2.5, right: 2.5),
                child: FadeInImage.memoryNetwork(
                  height: 150,
                  width: 100,
                  placeholder: kTransparentImage,
                  image: "https://image.tmdb.org/t/p/w500/" + movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2.5),
                      width: 100,
                      decoration: BoxDecoration(color: Colors.black45),
                      child: Text(
                        movie.title,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.bottomCenter,
              )
            ],
          ),
        ));
  }
}
