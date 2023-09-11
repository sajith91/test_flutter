import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/src/movies/movie_cubit.dart';
import 'package:test_flutter/src/movies/movie_model.dart';
import 'package:test_flutter/src/movies/movie_state.dart';

import '../util/database_helper.dart';

List<MovieModel> movie_list = [];

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    getMovieFromDB();
  }

  void getMovieFromDB() async {
    var dbHelper = MovieDataBaseHelper();
    List<MovieModel> _movie_list = await dbHelper.getMovies();
    setState(() {
      movie_list = _movie_list;
      print(movie_list.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (BuildContext context, MoviesState state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedState) {
            final movies = state.movies;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(movies[index].name ?? ""),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(movies[index].url ?? ""),
                  ),
                ),
              ),
            );
          } else if (state is ErrorState) {
            return const Center(
              child: Icon(Icons.close),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
