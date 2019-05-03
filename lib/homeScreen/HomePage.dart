import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:Talkies/auth/LoginForm.dart';
import 'package:Talkies/database/DbProvider.dart';
import 'package:Talkies/deatilPackage/DetailScreen.dart';
import 'package:Talkies/homeScreen/WebServiceCall.dart';
import 'package:Talkies/model/MoviesModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homePage();
  }
}

class _homePage extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scafoldKey,
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text("Talkies"),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  createMovieListView("now_playing", _scafoldKey),
                  createMovieListView("popular", _scafoldKey),
                  createMovieListView("top_rated", _scafoldKey),
                  createMovieListView("upcoming", _scafoldKey)
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

Widget createMovieListView(
    String movieType, GlobalKey<ScaffoldState> scaffoldKey) {
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
          List<MoviesModel> movies = snapshot.data;
          moviesLength = movies.length;
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(movieTypeTitle),
                    margin: EdgeInsets.all(10),
                  ),
                ],
              ),
              Container(
                height: 150,
                child: new ListView.builder(
                  itemCount: moviesLength,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                    return movieItem(movieTypeTitle, context, position, movies,
                        dbHelper, scaffoldKey);
                  },
                ),
              ),
            ],
          );
        }
      });
}

Widget movieItem(
    String movieTypeTitle,
    BuildContext context,
    int position,
    List<MoviesModel> movies,
    DbProvider dbHelper,
    GlobalKey<ScaffoldState> scaffoldKey) {
  return Dismissible(
    background: new Container(color: Colors.red),
    direction: DismissDirection.vertical,
    onDismissed: (direction) {},
    key: ObjectKey(movies[position]),
    child: Hero(
        tag: movies[position].id.toString() + "thumb" + movieTypeTitle,
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          final Hero toHero = toHeroContext.widget;
          return RotationTransition(
            turns: animation,
            child: toHero.child,
          );
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

//        Navigator.push(context, new CupertinoPageRoute(builder: (_)=> new AnimationDemoHome()));
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
                            color: Colors.green,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.bottomCenter,
              )
            ],
          ),
        )),
  );
}
