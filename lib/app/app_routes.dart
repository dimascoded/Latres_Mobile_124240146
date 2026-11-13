import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../controllers/app_controllers.dart';
import '../models/film.dart';
import '../views/detail.dart';
import '../views/login.dart';
import '../views/root.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const root = '/root';
  static const detail = '/detail';
}

class AppPages {
  static final pages = <GetPage<void>>[
    GetPage<void>(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage<void>(
      name: AppRoutes.root,
      page: () => const RootPage(),
      binding: BindingsBuilder(() {
        Get.put(RootController(nama: Get.arguments as String));
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage<void>(
      name: AppRoutes.detail,
      page: () => const DetailPage(),
      binding: BindingsBuilder(() {
        Get.put(DetailController(filmId: Get.arguments as int));
      }),
    ),
  ];
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(FavoritesController(Hive.box<Film>('favorites')), permanent: true);
  }
}
