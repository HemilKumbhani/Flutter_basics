
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_view_app/database/DbProvider.dart';
import 'package:web_view_app/model/MoviesModel.dart';
import 'home_page.dart';

List<Widget> createNowPlayingMovieItem(
    List<MoviesModel> movies, BuildContext context,HomePage  homepage) {
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
                   homepage._pushAnimation(context, movies[i], false);
                  } else {
                    context._pushAnimation(context, movies[i], true);
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
