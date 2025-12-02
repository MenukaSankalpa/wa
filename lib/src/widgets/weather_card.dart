// lib/src/widgets/weather_card.dart

import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final temp = weather.temp.toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // CITY NAME
          Text(
            weather.city,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // TEMP + ICON ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                '${Constants.iconUrl}${weather.icon}@2x.png',
                width: 85,
                height: 85,
              ),
              const SizedBox(width: 12),
              Text(
                '$temp°C',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // DESCRIPTION
          Text(
            weather.description,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70),
          ),

          const SizedBox(height: 14),

          // HUMIDITY + WIND ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(children: [
                const Icon(Icons.water_drop, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${weather.humidity}%',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ]),

              Row(children: [
                const Icon(Icons.air, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${weather.windSpeed} m/s',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
