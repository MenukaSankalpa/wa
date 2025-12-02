// lib/src/views/search/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  static const route = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Search box
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                prefixIcon: const Icon(Icons.location_city),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _ctrl.clear(),
                ),
              ),
              onSubmitted: (_) => _doSearch(prov),
            ),

            const SizedBox(height: 12),

            /// Search button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _searching
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.search),
                label: Text(_searching ? 'Searching...' : 'Search'),
                onPressed: _searching ? null : () => _doSearch(prov),
              ),
            ),

            const SizedBox(height: 20),

            /// Result section
            if (prov.current != null && !_searching)
              _buildSearchResult(context, prov),
          ],
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// Search action
  /// ------------------------------------------------------------
  Future<void> _doSearch(WeatherProvider prov) async {
    final query = _ctrl.text.trim();
    if (query.isEmpty) return;

    setState(() => _searching = true);

    try {
      await prov.fetchWeatherForCity(query);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Weather loaded successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _searching = false);
    }
  }

  /// ------------------------------------------------------------
  /// Result card UI
  /// ------------------------------------------------------------
  Widget _buildSearchResult(BuildContext context, WeatherProvider prov) {
    final w = prov.current!;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              Text(
                w.city,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                w.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '${w.temp.toStringAsFixed(0)}°C',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        /// Save favorite button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.favorite_border),
            label: const Text("Save to Favorites"),
            onPressed: () async {
              await prov.addFavorite(w.city);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Saved to favorites")),
              );
            },
          ),
        ),
      ],
    );
  }
}
