import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_view_app/TMDBConfig.dart';
import 'package:web_view_app/auth/login_form.dart';
import 'package:web_view_app/database/DbProvider.dart';
import 'package:web_view_app/database/User.dart';
import 'package:web_view_app/deatilPackage/deatilScreen.dart';
import 'package:web_view_app/homeScreen/WebServiceCall.dart';
import 'package:web_view_app/homeScreen/itemMovie.dart';
import 'package:web_view_app/model/MoviesModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homePage();
  }
}

Future<User> fetchUserFromDatabase() async {
  var dbHelper = DbProvider();
  Future<User> user = dbHelper.getUser();
  print(dbHelper.getUser());
  return user;
}

class _homePage extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("NowPlayingMovies"),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  createMovieListView("now_playing"),
                  createMovieListView("popular"),
                  createMovieListView("top_rated"),
                  createMovieListView("upcoming")
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

Widget createMovieListView(String movieType) {
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
          List movies = snapshot.data;
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
                  itemCount: movies.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                    MoviesModel movie = movies[position];
                    return movieItem(movie, movieTypeTitle, context, position);
                  },
                ),
              ),
            ],
          );
        }
      });
}

Hero movieItem(MoviesModel movie, String movieTypeTitle, BuildContext context,
    int position) {
  return Hero(
      tag: movie.title + "thumb" + movieTypeTitle,
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
          Navigator.of(context).push(new PageRouteBuilder(
              opaque: true,
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, _, __) {
                return DetailScreen(movie, position, movieTypeTitle);
              },
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return new FadeTransition(
                  opacity: animation,
                  child: new RotationTransition(
                    turns: new Tween<double>(begin: 0.0, end: 1.0)
                        .animate(animation),
                    child: child,
                  ),
                );
              }));
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
      ));
}
