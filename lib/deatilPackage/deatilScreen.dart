import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_view_app/deatilPackage/WebSerivceCaller.dart';
import 'package:web_view_app/deatilPackage/item_movie.dart';
import 'package:web_view_app/model/MoviesModel.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'dart:math' as math;
import 'package:palette_generator/palette_generator.dart';

class DetailScreen extends StatefulWidget {
  MoviesModel movieDetail;
  int index;
  String movieTypeTitle;
  List<MoviesModel> movies;

  DetailScreen(this.movieDetail, int index, String movieTypeTitle,
      List<MoviesModel> movies) {
    this.index = index;
    this.movies = movies;
    this.movieTypeTitle = movieTypeTitle;
  }

  @override
  State<StatefulWidget> createState() {
    print(movieDetail.toString());
    return _detailScreen(index, movieDetail, movies);
  }
}

class _detailScreen extends State<DetailScreen> {
  List<String> posterList = new List();
  int index;
  List<MoviesModel> movies;
  Rect region;
  PaletteGenerator paletteGenerator;

  _detailScreen(int index, MoviesModel movieDetail, List<MoviesModel> movies) {
    this.index = index;
    posterList.add(movieDetail.posterPath);
    posterList.add(movieDetail.backdropPath);
    this.movies = movies;
  }

//    region = Offset.zero & Size(MediaQuery.of(context).size.width, 250);

/*
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
                width: 500,
                child: PageView(
                  children: _allImageItem(movies),
                  pageSnapping: true,
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 400,
                width: 500,
                child: TransformerPageView(
                  loop: false,
                  itemCount: movies.length,
                  index: index,
                  onPageChanged: (position) {
                    setState(() {
                      index = position;
                    });
                  },
                  transformer: new PageTransformerBuilder(
                      builder: (Widget child, TransformInfo info) {
                    return Container(
                      child: Stack(
                        children: <Widget>[
                          ParallaxContainer(
                            child: Align(
                              child: GestureDetector(
                                onTap: () {
                                  buildPlayYoutubeVideoById();
                                },
                                child: new Container(
                                  height: 250,
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: "https://image.tmdb.org/t/p/w500/" +
                                        movies[info.index].backdropPath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              alignment: AlignmentDirectional.topCenter,
                            ),
                            position: info.position,
                            translationFactor: 10,
                          ),
                          Positioned(
                            left: 10,
                            bottom: 70,
                            child: ParallaxContainer(
                              position: info.position,
                              translationFactor: 500.0,
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
                                                  movies[info.index]
                                                      .posterPath),
                                          fit: BoxFit.contain)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 0,
                            child: ParallaxContainer(
                              position: info.position,
                              translationFactor: 500.0,
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
                                        movies[info.index].title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      margin: EdgeInsets.only(top: 20),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          width: 200,
                                          height: 100,
                                          margin: EdgeInsets.only(top: 10),
                                          child: SingleChildScrollView(
                                              child: new Text(
                                                  movies[info.index].overview)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                child: createSimilarMovieListView(movies[index].id),
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
            List<MoviesModel> movies = snapshot.data;
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
                      return movieItem(movie, widget.movieTypeTitle, context,
                          position, movies);
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
