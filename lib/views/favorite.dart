import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/app_routes.dart';
import '../controllers/app_controllers.dart';

class FavoritePage extends GetView<FavoritesController> {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite List")),
      body: Obx(() {
        final films = controller.films;

        if (films.isEmpty) {
          return const Center(child: Text('Belum ada film favorit'));
        }

        return ListView.builder(
          itemCount: films.length,
          itemBuilder: (context, index) {
            final film = films[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white38),
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: film.image.isEmpty
                    ? const SizedBox(width: 50, child: Icon(Icons.movie))
                    : Image.network(
                        film.image,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 50,
                            child: Icon(Icons.broken_image),
                          );
                        },
                      ),
                title: Text(film.name),
                subtitle: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 3),
                    Text(
                      film.rating.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.detail, arguments: film.id);
                },
                trailing: IconButton(
                  onPressed: () => controller.remove(film.id),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
