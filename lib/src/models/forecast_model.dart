// lib/src/models/forecast_model.dart

/// Forecast model for 3-hour interval forecast from OpenWeatherMap.
/// Each ForecastItem represents a single time slot (e.g., every 3 hours).

class ForecastItem {
  final DateTime date;
  final double temp;
  final String icon;

  ForecastItem({
    required this.date,
    required this.temp,
    required this.icon,
  });

  /// Converts JSON response into a ForecastItem object
  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      date: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
      temp: (json['main']['temp'] as num).toDouble(),
      icon: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['icon'] ?? '01d'
          : '01d',
    );
  }
}
