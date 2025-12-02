// lib/src/views/favorites/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/weather_provider.dart';
import '../../utils/constants.dart';

class FavoritesScreen extends StatelessWidget {
  static const route = '/favorites';

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);
    final box = Hive.box<String>(Constants.hiveBoxFavorites);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        centerTitle: true,
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<String> b, _) {
          final keys = b.keys.cast<String>().toList();

          /// ------- EMPTY UI -------
          if (keys.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      size: 75,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  const Text(
                    'No favorites added yet',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Search a city and tap the heart icon',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  )
                ],
              ),
            );
          }

          /// ------- LIST OF FAVORITES -------
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: keys.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),

            itemBuilder: (context, index) {
              final id = keys[index];
              final city = b.get(id) ?? '';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                  leading: const Icon(Icons.location_city, size: 32),

                  title: Text(
                    city,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  subtitle: const Text('Tap cloud to open weather'),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// LOAD WEATHER BUTTON
                      IconButton(
                        icon: const Icon(Icons.cloud, size: 28),
                        onPressed: () async {
                          await prov.fetchWeatherForCity(city);
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),

                      /// DELETE BUTTON
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => b.delete(id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
