import 'dart:async';

import 'package:Talkies/actordetail/WebServiceCaller.dart';
import 'package:Talkies/deatilPackage/DetailScreen.dart';
import 'package:Talkies/model/ActorDetailModel.dart';
import 'package:Talkies/model/ActorMoviesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class ActorDetail extends StatefulWidget {
  int personId;

  ActorDetail(this.personId);

  @override
  _ActorDetailState createState() => _ActorDetailState();
}

class _ActorDetailState extends State<ActorDetail> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            child: getActorDetails(),
          ),
        ),
      ),
    );
  }

  Widget getActorDetails() {
    return FutureBuilder(
      future: getActorsBiography(widget.personId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return new Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        else if (snapshot.hasData) {
          ActorDetailModel actorDetail = snapshot.data;
          return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 120.0,
                  height: 120.0,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(
                              "https://image.tmdb.org/t/p/w500/" +
                                  actorDetail.profilePath))),
                ),
                Text(actorDetail.name,
                    textScaleFactor: 1.5,
                    style: TextStyle(color: Colors.white)),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Birth Date : " +
                                DateFormat('dd-MM-yyyy')
                                    .format(actorDetail.birthday),
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.white,fontSize: 10,decoration: TextDecoration.underline,)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 150,
                        child: Text("Birth Place: " + actorDetail.placeOfBirth,
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.white,fontSize: 10,decoration: TextDecoration.underline,)),
                      ),
                    ),
                  ]),
                ),
                Text("About",
                    textScaleFactor: 2.0,
                    style: TextStyle(color: Colors.deepOrange)),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(5),
                    child: Text(
                      actorDetail.biography,
                      style: TextStyle(color: Colors.white),
                    )),
                Container(
                  child: getActorMovies(),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget getActorMovies() {
    return FutureBuilder(
        future: getActorsMovies(widget.personId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            ActorMoviesModel actorMovies = snapshot.data;
            return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: actorMovies.cast.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int position) {
                  var posterPath = actorMovies.cast[position].posterPath ?? "";
                  if (posterPath != null && posterPath.isNotEmpty) {
                    posterPath =
                        "https://image.tmdb.org/t/p/w500/" + posterPath;
                  }
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  DetailScreen(movie, position, movieTypeTitle, movies),
                              fullscreenDialog: true));
                    },
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 1.5, right: 1.5),
                            child: FadeInImage.assetNetwork(
                              height: 150,
                              width: 100,
                              placeholder: 'assets/images/icons8-picture-96.png',
                              image: posterPath,
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
                                  decoration:
                                      BoxDecoration(color: Colors.black45),
                                  child: Text(
                                    actorMovies.cast[position].title,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            alignment: Alignment.bottomCenter,
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
        });
  }
}
