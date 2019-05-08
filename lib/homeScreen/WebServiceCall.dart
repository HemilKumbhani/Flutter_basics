import 'dart:convert';
import 'dart:io';

import 'package:Talkies/TMDBConfig.dart';
import 'package:Talkies/model/MoviesModel.dart';

Future<MoviesModel> getMovies(String moviesType) async {
  String movies;
  switch (moviesType) {
    case "now_playing":
      movies = 'https://api.themoviedb.org/3/movie/now_playing?api_key=' +
          TMDBConfig.apiKey +
          '&page=' +
          '1';
      break;
    case "popular":
      movies = 'https://api.themoviedb.org/3/movie/popular?api_key=' +
          TMDBConfig.apiKey +
          '&page=' +
          '1';
      break;
    case "upcoming":
      movies = 'https://api.themoviedb.org/3/movie/upcoming?api_key=' +
          TMDBConfig.apiKey +
          '&page=' +
          '1';
      break;
    case "top_rated":
      movies = 'https://api.themoviedb.org/3/movie/top_rated?api_key=' +
          TMDBConfig.apiKey +
          '&page=' +
          '1';
      break;
  }

  var httpClient = new HttpClient();
  try {
    //Make APi call
    var request = await httpClient.getUrl(Uri.parse(movies));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var jsonResponse = await response.transform(utf8.decoder).join();

      //Decode Response
      var data = jsonDecode(jsonResponse);

      List resultList = data['results'];

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


