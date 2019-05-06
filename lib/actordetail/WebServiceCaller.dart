import 'dart:convert';
import 'dart:io';

import 'package:Talkies/TMDBConfig.dart';
import 'package:Talkies/model/ActorDetailModel.dart';
import 'package:Talkies/model/ActorMoviesModel.dart';

Future<ActorDetailModel> getActorsBiography(int person_id) async {
  String movies = 'https://api.themoviedb.org/3/person/$person_id/?api_key=' +
      TMDBConfig.apiKey +
      "&language=en-US";

  print(movies);

  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(movies));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsOnResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsOnResponse);

      ActorDetailModel actorDetail = ActorDetailModel.fromJson(data);
      return actorDetail;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

Future<ActorMoviesModel> getActorsMovies(int person_id) async {
  String movies =
      'https://api.themoviedb.org/3/person/$person_id/movie_credits?api_key=' +
          TMDBConfig.apiKey +
          "&language=en-US";

  print(movies);

  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(movies));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsOnResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsOnResponse);

      ActorMoviesModel actorMovies = ActorMoviesModel.fromJson(data);
      return actorMovies;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}
