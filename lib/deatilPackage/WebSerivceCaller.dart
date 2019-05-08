import 'dart:convert';
import 'dart:io';

import 'package:Talkies/TMDBConfig.dart';
import 'package:Talkies/model/MovieCreditsModel.dart';
import 'package:Talkies/model/MovieVideoModel.dart';
import 'package:Talkies/model/MoviesModel.dart';

Future<MoviesModel> getSimilarMovie(int movie_id) async {
  String movies =
      'https://api.themoviedb.org/3/movie/$movie_id/similar?api_key=' +
          TMDBConfig.apiKey +
          '&page=' +
          '1';

  print(movies);

  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(movies));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsOnResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsOnResponse);

      MoviesModel list = MoviesModel.fromJson(data);

      return list;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

Future<MovieVideoModel> getMovieVideoList(int movie_id) async {
  String movies =
      'https://api.themoviedb.org/3/movie/$movie_id/videos?api_key=' +
          TMDBConfig.apiKey +
          '&page=' +
          '1';

  print(movies);

  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(movies));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsOnResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsOnResponse);

      MovieVideoModel list = MovieVideoModel.fromJson(data);
      return list;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

Future<MovieCreditsModel> getMovieCreditsList(int movie_id) async {
  String movies =
      'https://api.themoviedb.org/3/movie/$movie_id/credits?api_key=' +
          TMDBConfig.apiKey;

  print(movies);

  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(movies));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsOnResponse = await response.transform(utf8.decoder).join();

      var data = jsonDecode(jsOnResponse);

      MovieCreditsModel list = MovieCreditsModel.fromJson(data);
      return list;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}
