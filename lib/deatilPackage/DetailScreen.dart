import 'package:Talkies/actordetail/ActorDetail.dart';
import 'package:Talkies/model/MovieCreditsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:Talkies/deatilPackage/ItemMovie.dart';
import 'package:Talkies/deatilPackage/WebSerivceCaller.dart';
import 'package:Talkies/model/MovieVideoModel.dart';
import 'package:Talkies/model/MoviesModel.dart';

class DetailScreen extends StatefulWidget {
  Result movieDetail;
  int index;
  String movieTypeTitle;
  List<Result> movies;

  DetailScreen(this.movieDetail, this.index, this.movieTypeTitle,
      this.movies) ;

  @override
  State<StatefulWidget> createState() {
    print(movieDetail.toString());
    return _detailScreen();
  }
}

class _detailScreen extends State<DetailScreen> {
  List<String> posterList = new List();
  Rect region;
  PaletteGenerator paletteGenerator;
  var mVideoId;



  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        backgroundColor: Colors.black,
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
                  itemCount: widget.movies.length,
                  index: widget.index,
                  onPageChanged: (position) {
                    getVideos(widget.movies[position].id);
                    setState(() {
                      widget.index = position;
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
                                  if (mVideoId != null)
                                    buildPlayYoutubeVideoById(mVideoId);
                                },
                                child: new Container(
                                  height: 250,
                                  child: Stack(
                                    children: <Widget>[
                                      FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image:
                                            "https://image.tmdb.org/t/p/w500/" +
                                                widget.movies[info.index].backdropPath,
                                        fit: BoxFit.cover,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/youtube.png',
                                            width: 55,
                                            height: 55,
                                            image: "youtube.png"),
                                      )
                                    ],
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
                                tag: widget.movieDetail.id.toString() +
                                    "thumb" +
                                    widget.movieTypeTitle,
                                child: new Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://image.tmdb.org/t/p/w500/" +
                                                  widget.movies[info.index]
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
                                        widget.movies[info.index].title,
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.deepOrangeAccent,
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
                                           widget. movies[info.index].overview,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
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
                  margin: EdgeInsets.all(10),
                  child: Text("Cast",
                      style: TextStyle(color: Colors.white),
                      textScaleFactor: 1.5)),
              Container(
                  height: 200, child: createCreditsMovie(widget.movies[widget.index].id)),
              Container(
                alignment: Alignment.bottomCenter,
                child: createSimilarMovieListView(widget.movies[widget.index].id),
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buildPlayYoutubeVideoById(String videoId) {
    FlutterYoutube.playYoutubeVideoById(
        apiKey: "AIzaSyBT_9O01_cgjAvjpWa2TDg-75F8AW5JbLA",
        videoId: videoId,
        autoPlay: true, //default falase
        fullScreen: false //default false
        );
  }

  void getVideos(int movie_id) {
    Future<MovieVideoModel> videoModel = getMovieVideoList(movie_id);
    videoModel.then((MovieVideoModel model) {
      mVideoId = model.results[0].key;
    });
  }

  Widget createCreditsMovie(int movie_id) {
    return new FutureBuilder(
      future: getMovieCreditsList(movie_id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return new Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        if (snapshot.hasData) {
          MovieCreditsModel movieCredits = snapshot.data;

          return ListView.builder(
              itemCount: movieCredits.cast.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, position) {
                var posterPath= movieCredits.cast[position].profilePath;
                if(posterPath!=null && posterPath.isNotEmpty){
                  posterPath="https://image.tmdb.org/t/p/w500/"+posterPath;
                }else{
                  posterPath= " ";
                }
                return Container(
                  height: 200,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          width: 120.0,
                          height: 120.0,
                          margin: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ActorDetail(movieCredits.cast[position].id),fullscreenDialog: true));
                            },
                          ),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new NetworkImage(
                                      posterPath)))),
                      new Text(movieCredits.cast[position].name,
                          style: TextStyle(color: Colors.white)),
                      Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: new Text(
                          movieCredits.cast[position].character,
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                );
              });
        }
      },
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
         else if (snapshot.hasData) {
            MoviesModel movies = snapshot.data;
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text("Similar Movie",
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.white)),
                      margin: EdgeInsets.all(10),
                    ),
                  ],
                ),
                Container(
                  height: 150,
                  child: new ListView.builder(
                    itemCount: movies.results.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, position) {
                      return movieItem(movies.results[position], movies.results[position].title, context,
                          position,movies.results);
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
