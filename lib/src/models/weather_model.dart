// lib/src/models/weather_model.dart

/// Weather model for current weather data.
/// Converts JSON from OpenWeatherMap into a clean Dart object.

class Weather {
  final String city;
  final double temp;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;
  final int dt;

  Weather({
    required this.city,
    required this.temp,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.dt,
  });

  /// Factory method to convert API JSON to Weather object
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? '',
      temp: (json['main']['temp'] as num).toDouble(),
      description: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['description'] ?? ''
          : '',
      humidity: (json['main']['humidity'] as num).toInt(),
      windSpeed: (json['wind'] != null)
          ? (json['wind']['speed'] as num).toDouble()
          : 0.0,
      icon: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['icon'] ?? '01d'
          : '01d',
      dt: json['dt'] ?? 0,
    );
  }
}
