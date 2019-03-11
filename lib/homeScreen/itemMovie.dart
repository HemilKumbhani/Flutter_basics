import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_view_app/database/DbProvider.dart';
import 'package:web_view_app/deatilPackage/deatilScreen.dart';
import 'package:web_view_app/model/MoviesModel.dart';

List<Widget> createNowPlayingMovieItem(
    List<MoviesModel> movies, BuildContext context, String movieTypeTitle) {
  List<Widget> listElementWidget = new List<Widget>();
  var dbHelper = DbProvider();
  dbHelper.initDb();
  /**
   * Making item for list
   */
  if (movies != null) {
    int sizeOfList = movies.length;
    for (int i = 0; i < sizeOfList; i++) {
      MoviesModel movie = movies[i];
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
                dbHelper.getUser().then((dynamic res) {
                  if (res == null) {
                    _pushAnimation(context, movies[i], i, false,movieTypeTitle);
                  } else {
                    _pushAnimation(context, movies[i], i, true,movieTypeTitle);
                  }
                });

                /* Navigator.push(context,
                    new MaterialPageRoute(builder: (_) => new DetailScreen()));*/
              }
            },
            child: Hero(
              tag: movie.title + "thumb" +movieTypeTitle,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: imageUrl,
                fit: BoxFit.cover,
              ),
            )),
      );
      listElementWidget.add(listItem);
    }
  }
  return listElementWidget;
}

void _pushAnimation(
    BuildContext context, MoviesModel movies, int index, bool isLoggedIn, String movieTypeTitle) {
/*  Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (BuildContext context, _, __) {
        if (!isLoggedIn) {
          return new LoginForm(movies);
        } else {
          return new DetailScreen(movies, index);
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
      }));*/

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailScreen(movies, index,movieTypeTitle),
          fullscreenDialog: true));
}
