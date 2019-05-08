// To parse this JSON data, do
//
//     final actorMoviesModel = actorMoviesModelFromJson(jsonString);

import 'dart:convert';

import 'package:Talkies/model/MoviesModel.dart';

ActorMoviesModel actorMoviesModelFromJson(String str) =>
    ActorMoviesModel.fromJson(json.decode(str));

String actorMoviesModelToJson(ActorMoviesModel data) =>
    json.encode(data.toJson());

class ActorMoviesModel {
  List<Result> cast;
  List<Cast> crew;
  int id;

  ActorMoviesModel({
    this.cast,
    this.crew,
    this.id,
  });

  factory ActorMoviesModel.fromJson(Map<String, dynamic> json) =>
      new ActorMoviesModel(
        cast:
            new List<Result>.from(json["cast"].map((x) => Result.fromJson(x))),
        crew: new List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cast": new List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": new List<dynamic>.from(crew.map((x) => x.toJson())),
        "id": id,
      };
}

class Cast {
  String character;
  String creditId;
  String posterPath;
  int id;
  bool video;
  int voteCount;
  bool adult;
  String backdropPath;
  List<int> genreIds;
  OriginalLanguage originalLanguage;
  String originalTitle;
  double popularity;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;
  String department;
  String job;

  Cast({
    this.character,
    this.creditId,
    this.posterPath,
    this.id,
    this.video,
    this.voteCount,
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.originalLanguage,
    this.originalTitle,
    this.popularity,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.department,
    this.job,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => new Cast(
        character: json["character"] == null ? null : json["character"],
        creditId: json["credit_id"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        id: json["id"],
        video: json["video"],
        voteCount: json["vote_count"],
        adult: json["adult"],
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        genreIds: new List<int>.from(json["genre_ids"].map((x) => x)),
        originalLanguage: originalLanguageValues.map[json["original_language"]],
        originalTitle: json["original_title"],
        popularity: json["popularity"].toDouble(),
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        releaseDate: json["release_date"] == null ? null : json["release_date"],
        department: json["department"] == null ? null : json["department"],
        job: json["job"] == null ? null : json["job"],
      );

  Map<String, dynamic> toJson() => {
        "character": character == null ? null : character,
        "credit_id": creditId,
        "poster_path": posterPath == null ? null : posterPath,
        "id": id,
        "video": video,
        "vote_count": voteCount,
        "adult": adult,
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "genre_ids": new List<dynamic>.from(genreIds.map((x) => x)),
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "popularity": popularity,
        "title": title,
        "vote_average": voteAverage,
        "overview": overview,
        "release_date": releaseDate == null ? null : releaseDate,
        "department": department == null ? null : department,
        "job": job == null ? null : job,
      };
}

enum OriginalLanguage { EN }

final originalLanguageValues = new EnumValues({"en": OriginalLanguage.EN});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
