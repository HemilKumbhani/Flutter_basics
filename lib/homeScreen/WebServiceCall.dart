import 'dart:convert';
import 'dart:io';

import 'package:web_view_app/TMDBConfig.dart';
import 'package:web_view_app/model/MoviesModel.dart';

Future<List<MoviesModel>> getMovies(String moviesType) async {
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

      List<MoviesModel> list = createNowPlayingList(resultList);
      return list;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

List<MoviesModel> createNowPlayingList(List data) {
  List<MoviesModel> list = new List();
  for (int i = 0; i < data.length; i++) {
    var id = data[i]["id"];
    String title = data[i]["title"];
    String posterPath = data[i]["poster_path"];
    String backdropImage = data[i]["backdrop_path"];
    String originalTitle = data[i]["original_title"];
    var voteAverage = data[i]["vote_average"];
    String overview = data[i]["overview"];
    String releaseDate = data[i]["release_date"];

    MoviesModel movie = MoviesModel(id, title, posterPath, backdropImage,
        originalTitle, voteAverage, overview, releaseDate);
    list.add(movie);
  }
  return list;
}
