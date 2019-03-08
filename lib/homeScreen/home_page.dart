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
import 'package:web_view_app/model/NowPlayingMovie.dart';

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

Future<List<NowPlayingMovie>> getNowPlayingMOvies() async {
  final String nowPlaying =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=' +
          TMDBConfig.apiKey +
          '&page=' +
          '1';
  var httpClient = new HttpClient();
  try {
    //Make APi call
    var request = await httpClient.getUrl(Uri.parse(nowPlaying));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonResponse = await response.transform(utf8.decoder).join();

      //Decode Response
      var data = jsonDecode(jsonResponse);

      List resultList = data['results'];

      List<NowPlayingMovie> list = createNowPlayingList(resultList);
      return list;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

List<NowPlayingMovie> createNowPlayingList(List data) {
  List<NowPlayingMovie> list = new List();
  for (int i = 0; i < data.length; i++) {
    var id = data[i]["id"];
    String title = data[i]["title"];
    String posterPath = data[i]["poster_path"];
    String backdropImage = data[i]["backdrop_path"];
    String originalTitle = data[i]["original_title"];
    var voteAverage = data[i]["vote_average"];
    String overview = data[i]["overview"];
    String releaseDate = data[i]["release_date"];

    NowPlayingMovie movie = NowPlayingMovie(id, title, posterPath,
        backdropImage, originalTitle, voteAverage, overview, releaseDate);
    list.add(movie);
  }
  return list;
}

_pushAnimation(BuildContext context, NowPlayingMovie movies, bool isLoggedIn) {
  Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (BuildContext context, _, __) {
        if (!isLoggedIn) {
          return new LoginForm(movies);
        } else {
          return new DetailScreen(movies);
        }
      },
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(
          opacity: animation,
          child: new RotationTransition(
            turns: new Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        );
      }));
}

List<Widget> createNowPlayingMovieItem(
    List<NowPlayingMovie> movies, BuildContext context) {
  List<Widget> listElementWidget = new List<Widget>();
  var dbHelper = DbProvider();
  dbHelper.initDb();
  /**
   * Making item for list
   */
  if (movies != null) {
    int sizeOfList = movies.length;
    for (int i = 0; i < sizeOfList; i++) {
      NowPlayingMovie movie = movies[i];
      //ImageURl
      var imageUrl = "https://image.tmdb.org/t/p/w500/" + movie.posterPath;
      //List Item Created with an image of Poster
      var listItem = new GridTile(
        //Footer of GridBlock
        footer: new GridTileBar(
          backgroundColor: Colors.black45,
          title: new Text(movie.title),
        ),
        //onClick of whole item,
        child: GestureDetector(
            onTap: () {
              if (movie.id > 0) {
                /*new FutureBuilder(
                    future: fetchUserFromDatabase(),
                    builder: (context, snapshot) {
                      print("data:" + snapshot.hasData.toString());
                      if (snapshot.data.length == 0) {
                        return _pushAnimation(context, movies[i], false);
                      } else if (snapshot.hasData) {
                        return _pushAnimation(context, movies[i], true);
                      }
                    });*/

                dbHelper.getUser().then((dynamic res) {
                  if (res == null) {
                    _pushAnimation(context, movies[i], false);
                  } else {
                    _pushAnimation(context, movies[i], true);
                  }
                });

                /* Navigator.push(context,
                    new MaterialPageRoute(builder: (_) => new DetailScreen()));*/
              }
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: imageUrl,
              fit: BoxFit.cover,
            )),
      );
      listElementWidget.add(listItem);
    }
  }
  return listElementWidget;
}

class _homePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("NowPlayingMovies"),
      ),
      body: new FutureBuilder(
          future: getNowPlayingMOvies(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return new Container(
                child: new Center(
                  child: new CircularProgressIndicator(),
                ),
              );
            if (snapshot.hasData) {
              List movies = snapshot.data;
              return new CustomScrollView(
                primary: false,
                slivers: <Widget>[
                  new SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: new SliverGrid.count(
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      crossAxisCount: 2,
                      children: createNowPlayingMovieItem(movies, context),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}

FutureOr onUserAvialable() {}
