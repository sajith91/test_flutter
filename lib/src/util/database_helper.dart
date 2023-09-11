import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../movies/movie_model.dart';

class MovieDataBaseHelper {
  static Database?_db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPathMovie = join(documentsDirectory.path, "movie.db");
    bool dbExists = await io.File(dbPathMovie).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data = await rootBundle.load( join("assets", "movie.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPathMovie).writeAsBytes(bytes, flush: true);
    }

    var theDb = await openDatabase(dbPathMovie,version: 1);
    return theDb;
  }

  /// get all the movies from db
  Future<List<MovieModel>> getAllMoviesFromDB() async {
    // var dbClient = await db;
    // if (_db == null) {
    //   throw "bd is not initiated, initiate using [init(db)] function";
    // }
    late List<Map> movies;

    await _db?.transaction((txn) async {
      movies = await txn.query(
        "tb_movie",
        columns: [
          "name",
          "url",
        ],
      );
    });

    return movies.map((e) => MovieModel.fromJson(e)).toList();
  }

  Future<List<MovieModel>> getMovies() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM tb_movie');
    return list.map((e) => MovieModel.fromJson(e)).toList();
  }

}



// class MovieDataBaseHelper {
//   late Database _db;
//
//
//   Future<void> init() async {
//     io.Directory applicationDirectory =
//         await getApplicationDocumentsDirectory();
//
//     String dbPathMovie = path.join(applicationDirectory.path, "movie.db");
//     bool dbMovieExists  = await io.File(dbPathMovie).exists();
//
//     if (!dbMovieExists) {
//       // Copy from asset
//       ByteData data = await rootBundle.load(path.join("assets", "eng_dictionary.db"));
//       List<int> bytes =
//       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//       // Write and flush the bytes written
//       await io.File(dbPathMovie).writeAsBytes(bytes, flush: true);
//     }
//
//     this._db = await openDatabase(dbPathMovie);
//   }
//
//
//   /// get all the movies from db
//   Future<List<MovieModel>> getAllMoviesFromDB() async {
//     if (_db == null) {
//       throw "bd is not initiated, initiate using [init(db)] function";
//     }
//    late List<Map> movies;
//
//     await _db.transaction((txn) async {
//       movies = await txn.query(
//         "tb_movie",
//         columns: [
//           "name",
//           "url",
//         ],
//       );
//     });
//
//     return movies.map((e) => MovieModel.fromJson(e)).toList();
//   }

//}