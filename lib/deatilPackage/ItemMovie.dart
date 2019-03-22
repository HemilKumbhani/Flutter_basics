import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_view_app/deatilPackage/DetailScreen.dart';
import 'package:web_view_app/model/MoviesModel.dart';

Hero movieItem(MoviesModel movie, String movieTypeTitle, BuildContext context,
    int position, List<MoviesModel> movies) {
  return Hero(
      tag: movie.id.toString() + "thumb" + movieTypeTitle,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      DetailScreen(movie, position, movieTypeTitle, movies),
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