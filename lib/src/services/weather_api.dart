// lib/src/services/weather_api.dart

import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../utils/constants.dart';

/// Weather API Service using Dio
/// Handles all requests to OpenWeatherMap
class WeatherApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  /// ------------------------------------------------------------
  /// Get current weather by city name
  /// ------------------------------------------------------------
  Future<Weather> fetchCurrentWeatherByCity(String city) async {
    try {
      final res = await _dio.get(
        '/weather',
        queryParameters: {
          'q': city,
          'appid': Constants.openWeatherApiKey,
          'units': 'metric',
        },
      );

      return Weather.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load weather for $city: $e');
    }
  }

  /// ------------------------------------------------------------
  /// Get current weather using latitude & longitude
  /// ------------------------------------------------------------
  Future<Weather> fetchCurrentWeatherByCoords(double lat, double lon) async {
    try {
      final res = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': Constants.openWeatherApiKey,
          'units': 'metric',
        },
      );

      return Weather.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load weather at location: $e');
    }
  }

  /// ------------------------------------------------------------
  /// Get 5-day / 3-hour forecast data
  /// ------------------------------------------------------------
  Future<List<ForecastItem>> fetch5DayForecast(String city) async {
    try {
      final res = await _dio.get(
        '/forecast',
        queryParameters: {
          'q': city,
          'appid': Constants.openWeatherApiKey,
          'units': 'metric',
        },
      );

      final dataList = res.data['list'] as List;

      return dataList
          .map((item) => ForecastItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load forecast for $city: $e');
    }
  }
}
