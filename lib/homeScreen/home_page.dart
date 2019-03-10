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
        body: Container(
            child: Column(
          children: <Widget>[
            createMovieListView("now_playing"),
            createMovieListView("popular"),
            createMovieListView("top_rated"),
            createMovieListView("upcoming")
          ],
        )));
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
        if (!snapshot.hasData)
          return new Container(
            child: new Center(
              child: new CircularProgressIndicator(),
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
                    child: Text(movieTypeTitle),
                    margin: EdgeInsets.all(10),
                  ),
                ],
              ),
              new Container(
                child: Container(
                  height: 200,
                  child: new CustomScrollView(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    slivers: <Widget>[
                      new SliverPadding(
                        padding: const EdgeInsets.all(10.0),
                        sliver: new SliverGrid.count(
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          crossAxisCount: 1,
                          children: createNowPlayingMovieItem(movies, context),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      });
}
