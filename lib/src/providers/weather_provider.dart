// lib/src/providers/weather_provider.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_api.dart';
import '../utils/constants.dart';

/// Provider that handles:
/// ✔ Fetching current weather
/// ✔ Fetching forecast
/// ✔ Managing favorites (Hive)
/// ✔ Handling loading state
/// ✔ Location services
class WeatherProvider extends ChangeNotifier {
  final WeatherApi _api = WeatherApi();

  Weather? current;
  List<ForecastItem> forecast = [];
  bool loading = false;
  String? errorMessage;

  final Box<String> _favoritesBox =
  Hive.box<String>(Constants.hiveBoxFavorites);

  /// ------------------------------------------------------------
  /// Fetch weather by city name
  /// ------------------------------------------------------------
  Future<void> fetchWeatherForCity(String city) async {
    try {
      _startLoading();

      current = await _api.fetchCurrentWeatherByCity(city);
      forecast = await _api.fetch5DayForecast(city);

      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load weather for $city';
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  /// ------------------------------------------------------------
  /// Fetch weather based on device's GPS location
  /// ------------------------------------------------------------
  Future<void> fetchWeatherForCurrentLocation() async {
    try {
      _startLoading();

      final pos = await _determinePosition();

      current = await _api.fetchCurrentWeatherByCoords(
        pos.latitude,
        pos.longitude,
      );

      forecast = await _api.fetch5DayForecast(current!.city);

      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load weather for your location';
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  /// ------------------------------------------------------------
  /// Favorites (Hive Local Storage)
  /// ------------------------------------------------------------
  List<Map<String, String>> get favorites {
    return _favoritesBox.keys.map((key) {
      return {
        'id': key.toString(),
        'city': _favoritesBox.get(key) ?? '',
      };
    }).toList();
  }

  Future<void> addFavorite(String city) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _favoritesBox.put(id, city);
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    await _favoritesBox.delete(id);
    notifyListeners();
  }

  /// ------------------------------------------------------------
  /// Internal helpers
  /// ------------------------------------------------------------
  void _startLoading() {
    loading = true;
    notifyListeners();
  }

  void _stopLoading() {
    loading = false;
    notifyListeners();
  }

  /// ------------------------------------------------------------
  /// Location permission handler
  /// ------------------------------------------------------------
  Future<Position> _determinePosition() async {
    // Check service availability
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Enable location services in settings.');
    }

    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Enable them in app settings.',
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied by user.');
      }
    }

    // Return actual GPS position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
