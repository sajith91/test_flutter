class MovieModel {
  String? url;
  String? name;

  MovieModel({
    this.name,
    this.url,
  });

  factory MovieModel.fromJson(Map<dynamic, dynamic> json) => MovieModel(
    name: json["name"],
    url: json["url"]
  );
}

//test commit


//test