import 'package:dio/dio.dart';
import 'package:test_flutter/src/movies/movie_model.dart';

class MovieRepository {
  const MovieRepository(this.client);

  final Dio client;

  Future<List<MovieModel>> getMovies() async {
    try {
      const url =
          'https://api.themoviedb.org/3/trending/movie/week?api_key=060e7c76aff06a20ca4a875981216f3f';

      final response = await client.get(url);
      final movies = List<MovieModel>.of(response.data['results']
          .map<MovieModel>((json) => MovieModel(
              name: json['title'],
              url: 'https://image.tmdb.org/t/p/w185${json['poster_path']}')));

      return movies;
    } catch (e) {
      rethrow;
    }
  }
}