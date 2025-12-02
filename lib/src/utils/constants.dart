// lib/src/utils/constants.dart
// Global constants used across the Weather App

class Constants {
  /// ------------------------------------------------------------
  /// OPENWEATHERMAP API KEY (REQUIRED)
  /// Replace with your actual API key.
  /// ------------------------------------------------------------
  static const String openWeatherApiKey = '9e6f453decea71ff7ad8d217aa9b1486';

  /// ------------------------------------------------------------
  /// HIVE LOCAL DATABASE
  /// Name of the Hive box used to store favorite cities
  /// ------------------------------------------------------------
  static const String hiveBoxFavorites = 'favorites_box';

  /// ------------------------------------------------------------
  /// API BASE URL
  /// OpenWeatherMap API base path
  /// ------------------------------------------------------------
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// ------------------------------------------------------------
  /// WEATHER ICON URL
  /// Used to load weather icons from OpenWeatherMap
  /// Example: icon_url/10d@2x.png
  /// ------------------------------------------------------------
  static const String iconUrl = 'https://openweathermap.org/img/wn/';
}
