import 'package:Talkies/deatilPackage/WebSerivceCaller.dart';
import 'package:Talkies/model/MovieVideoModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:Talkies/auth/LoginForm.dart';
import 'package:Talkies/database/DbProvider.dart';
import 'package:Talkies/deatilPackage/DetailScreen.dart';
import 'package:Talkies/homeScreen/WebServiceCall.dart';
import 'package:Talkies/model/MoviesModel.dart';
import 'dart:math' as math ;


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homePage();
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _homePage extends State<HomePage>   with SingleTickerProviderStateMixin  {
  ScrollController _scrollController = new ScrollController();
  GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SliverPersistentHeader makeHeader(String headerText) {
      return SliverPersistentHeader(
        pinned: true,
        delegate: _SliverAppBarDelegate(
          minHeight: 60.0,
          maxHeight: 150.0,
          child: Container(
              color: Colors.black),
        ),
      );
    }

    return Scaffold(
        key: _scafoldKey,
        appBar: AppBar(title: Text("Talkies",style: TextStyle(fontSize: 14,color: Colors.white),textScaleFactor: 1.5,),backgroundColor: Colors.black,),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: CustomScrollView(
                slivers: <Widget>[
                   SliverAppBar(
                    pinned: true,
                    expandedHeight: 250.0,
                    backgroundColor: Colors.black,
                    flexibleSpace: createMovieListView("now_playing", _scafoldKey,rotationController),
                  ), SliverList(
                    delegate: SliverChildListDelegate([
                        createMovieListView("popular", _scafoldKey,rotationController),
                      ],
                    ),
                  ),
                  makeHeader("Popular"),
                  SliverList(
                    delegate: SliverChildListDelegate([
                        createMovieListView("popular", _scafoldKey,rotationController),
                      ],
                    ),
                  ),
                  makeHeader("Top Rated"),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                          createMovieListView("top_rated", _scafoldKey,rotationController),
                      ],
                    ),
                  ),
                makeHeader("UpComing"),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  createMovieListView("upcoming", _scafoldKey,rotationController)
                ],
              ),
            )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
            )
          ],
        ));
  }
}
int moviesLength;
var mVideoId;
Widget createMovieListView(
    String movieType, GlobalKey<ScaffoldState> scaffoldKey,rotationController) {
  var dbHelper = DbProvider();
  dbHelper.initDb();

  String movieTypeTitle;
  switch (movieType) {
    case "now_playing":
      movieTypeTitle = "Now playing movie";
      break;
    case "popular":
      movieTypeTitle = "Popular movie";
      break;
    case "top_rated":
      movieTypeTitle = "Top Rated";
      break;
    case "upcoming":
      movieTypeTitle = "Upcoming";
      break;
  }

  return new FutureBuilder(
      future: getMovies(movieType),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return new Container();
        if (snapshot.hasData) {
          MoviesModel movies = snapshot.data;
          moviesLength = movies.results.length;

          if(movieType=="now_playing"){
            return  Container(
              height: 400,
              width: 500,
              child: TransformerPageView(
                loop: false,
                itemCount: moviesLength,
                onPageChanged: (position) {
                  getVideos(movies.results[position].id);
                  scaffoldKey.currentState.setState(() {
//                    rotationController.forward(from: 0.0);

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
                                          movies.results[info.index].backdropPath,
                                          fit: BoxFit.cover,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(movies.results[info.index].title,textScaleFactor: 1.5,style: TextStyle(color: Colors.white,backgroundColor: Colors.black26,fontSize: 20))
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
                          ],
                        ),
                      );
                    }),
                scrollDirection: Axis.horizontal,
              ),
            );
          }
          return Container(
            height: 250,
            child: new ListView.builder(
              itemCount: moviesLength,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, position) {
                return movieItem(movieTypeTitle, context, position, movies.results,
                    dbHelper, scaffoldKey);
              },
            ),
          );
        }
      });
}
void getVideos(int movie_id) {
  Future<MovieVideoModel> videoModel = getMovieVideoList(movie_id);
  videoModel.then((MovieVideoModel model) {
    mVideoId = model.results[0].key;
  });
}
void buildPlayYoutubeVideoById(String videoId) {
  FlutterYoutube.playYoutubeVideoById(
      apiKey: "AIzaSyBT_9O01_cgjAvjpWa2TDg-75F8AW5JbLA",
      videoId: videoId,
      autoPlay: true, //default falase
      fullScreen: false //default false
  );
}

Widget movieItem(
    String movieTypeTitle,
    BuildContext context,
    int position,
    List<Result> movies,
    DbProvider dbHelper,
    GlobalKey<ScaffoldState> scaffoldKey) {
  return Hero(
      tag: movies[position].id.toString() + "thumb" + movieTypeTitle,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        final Hero toHero = toHeroContext.widget;
        return toHero.child;
      },
      child: GestureDetector(
        onTap: () {
          dbHelper.getUser().then((dynamic res) {
            if (res == null) {
              Navigator.push(
                  context,
                  new CupertinoPageRoute(
                      builder: (_) => new LoginForm(movies[position],
                          position, movieTypeTitle, movies)));
            } else {
              Navigator.push(
                  context,
                  new CupertinoPageRoute(
                      builder: (_) => new DetailScreen(movies[position],
                          position, movieTypeTitle, movies)));
            }
          });

        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 2.5, right: 2.5),
              child: FadeInImage.memoryNetwork(
                height: 260,
                width: 100,
                placeholder: kTransparentImage,
                image: "https://image.tmdb.org/t/p/w500/" +
                    movies[position].posterPath,
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
                      movies[position].title,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
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
