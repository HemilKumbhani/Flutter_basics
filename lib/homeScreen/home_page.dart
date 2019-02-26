import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_view_app/TMDBConfig.dart';
import 'package:web_view_app/deatilPackage/deatilScreen.dart';
import 'package:web_view_app/model/NowPlayingMovie.dart';
import 'package:web_view_app/auth/login_form.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homePage();
  }
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

List<Widget> createNowPlayingMovieItem(
    List<NowPlayingMovie> movies, BuildContext context) {
  List<Widget> listElementWidget = new List<Widget>();
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
                Navigator.push(context,
                    new MaterialPageRoute(builder: (_) => new DetailScreen()));
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
