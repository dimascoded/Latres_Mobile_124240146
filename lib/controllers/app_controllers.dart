import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/api_service.dart';
import '../app/app_routes.dart';
import '../models/film.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final authPref = await SharedPreferences.getInstance();
    final isLoggedIn = authPref.getBool('isLoggedIn') ?? false;
    final username = authPref.getString('username') ?? '';

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.root, arguments: username);
    }
  }

  Future<bool> login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username == '124240146' && password == '123') {
      final authPref = await SharedPreferences.getInstance();
      await authPref.setBool('isLoggedIn', true);
      await authPref.setString('username', username);

      Get.offAllNamed(AppRoutes.root, arguments: username);
      debugPrint('Login Berhasil');
      return true;
    }

    debugPrint('Login Gagal');
    return false;
  }

  Future<void> logout() async {
    final authPref = await SharedPreferences.getInstance();
    await authPref.setBool('isLoggedIn', false);
    await authPref.remove('username');
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class RootController extends GetxController {
  RootController({required this.nama});

  final String nama;
  final selectedIndex = 0.obs;

  void selectPage(int index) {
    selectedIndex.value = index;
  }
}

class HomeController extends GetxController {
  final films = <Film>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFilms();
  }

  Future<void> fetchFilms() async {
    final dataFilm = await getFilm();
    films.assignAll(dataFilm);
    isLoading.value = false;
  }
}

class FavoritesController extends GetxController {
  FavoritesController(this._box);

  final Box<Film> _box;
  final films = <Film>[].obs;

  @override
  void onInit() {
    super.onInit();
    _refreshFilms();
  }

  bool contains(int filmId) => _box.containsKey(filmId);

  Future<void> toggle(Film film) async {
    if (_box.containsKey(film.id)) {
      await _box.delete(film.id);
    } else {
      await _box.put(film.id, film);
    }
    _refreshFilms();
  }

  Future<void> remove(int filmId) async {
    await _box.delete(filmId);
    _refreshFilms();
  }

  void _refreshFilms() {
    films.assignAll(_box.values);
  }
}

class DetailController extends GetxController {
  DetailController({required this.filmId});

  final int filmId;
  final film = Rxn<Film>();
  final isLoading = true.obs;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFilm();
  }

  Future<void> fetchFilm() async {
    final dataFilm = await getSingleFilm(filmId);
    film.value = dataFilm;
    isFavorite.value = Get.find<FavoritesController>().contains(dataFilm.id);
    isLoading.value = false;
  }

  Future<void> toggleFavorite() async {
    final currentFilm = film.value;
    if (currentFilm == null) return;

    await Get.find<FavoritesController>().toggle(currentFilm);
    isFavorite.value = Get.find<FavoritesController>().contains(currentFilm.id);
  }
}
