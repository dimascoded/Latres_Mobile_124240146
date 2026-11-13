import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/film.dart';

String apiURL = "https://api.tvmaze.com/shows";

Future<List<Film>> getFilm() async {
  final response = await http.get(Uri.parse(apiURL));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((film) => Film.fromJson(film as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Gagal ngambil produk');
  }
}

Future<Film> getSingleFilm(int id) async {
  final response = await http.get(Uri.parse("$apiURL/$id"));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    Map<String, dynamic> product = data;

    return Film.fromJson(product);
  } else {
    throw Exception('Gagal ngambil produk');
  }
}
