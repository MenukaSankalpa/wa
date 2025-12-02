// lib/src/views/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weather_provider.dart';
import '../../widgets/weather_card.dart';
import '../search/search_screen.dart';
import '../favorites/favorites_screen.dart';
import '../forecast/forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    /// Fetch weather on startup using device location
    final prov = Provider.of<WeatherProvider>(context, listen: false);
    prov.fetchWeatherForCurrentLocation().catchError((_) {});
  }

  /// Refresh manually (pull-to-refresh or button)
  Future<void> _refresh() async {
    final prov = Provider.of<WeatherProvider>(context, listen: false);
    if (prov.current != null) {
      await prov.fetchWeatherForCity(prov.current!.city);
    } else {
      await prov.fetchWeatherForCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, SearchScreen.route),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () =>
                Navigator.pushNamed(context, FavoritesScreen.route),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: prov.loading ? null : _refresh,
          ),
        ],
      ),

      /// MAIN BODY
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())

      /// If no weather loaded
          : prov.current == null
          ? _buildEmptyState(context)

      /// If weather is available
          : RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              WeatherCard(weather: prov.current!),
              const SizedBox(height: 16),

              /// Forecast Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '5-Day Forecast',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                        context, ForecastScreen.route),
                    child: const Text('View Chart'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Horizontal forecast list
              _buildForecastList(prov, context),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// EMPTY STATE UI
  /// ------------------------------------------------------------
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('No weather data available.'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.location_on),
            label: const Text('Use Current Location'),
            onPressed: () {
              final prov =
              Provider.of<WeatherProvider>(context, listen: false);
              prov.fetchWeatherForCurrentLocation();
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text('Search City'),
            onPressed: () =>
                Navigator.pushNamed(context, SearchScreen.route),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// FORECAST LIST UI
  /// ------------------------------------------------------------
  Widget _buildForecastList(WeatherProvider prov, BuildContext context) {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: prov.forecast.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final f = prov.forecast[index];

          return Container(
            width: 95,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Date
                Text(
                  '${f.date.month}/${f.date.day}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(height: 4),

                /// Weather Icon
                Image.network(
                  'https://openweathermap.org/img/wn/${f.icon}@2x.png',
                  width: 48,
                  height: 48,
                ),

                const SizedBox(height: 4),

                /// Temperature
                Text(
                  '${f.temp.toStringAsFixed(0)}°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
