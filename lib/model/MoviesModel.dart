import 'dart:convert';

MoviesModel movieModelFromJson(String str) => MoviesModel.fromJson(json.decode(str));

String movieModelToJson(MoviesModel data) => json.encode(data.toJson());

class MoviesModel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  MoviesModel({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MoviesModel.fromJson(Map<String, dynamic> json) => new MoviesModel(
    page: json["page"],
    results: new List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": new List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  OriginalLanguage originalLanguage;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  double popularity;

  Result({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.popularity,
  });

  factory Result.fromJson(Map<String, dynamic> json) => new Result(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    genreIds: new List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    originalLanguage: originalLanguageValues.map[json["original_language"]],
    originalTitle: json["original_title"],
    overview: json["overview"],
    posterPath: json["poster_path"],
    releaseDate: json["release_date"],
    title: json["title"],
    video: json["video"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
    popularity: json["popularity"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": new List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguageValues.reverse[originalLanguage],
    "original_title": originalTitle,
    "overview": overview,
    "poster_path": posterPath,
    "release_date": releaseDate,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "popularity": popularity,
  };
}

enum OriginalLanguage { EN }

final originalLanguageValues = new EnumValues({
  "en": OriginalLanguage.EN
});

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