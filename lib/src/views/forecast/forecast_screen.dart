// lib/src/views/forecast/forecast_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../providers/weather_provider.dart';
import '../../models/forecast_model.dart';

class ForecastScreen extends StatelessWidget {
  static const route = '/forecast';

  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WeatherProvider>(context);
    final data = prov.forecast;

    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast Chart'),
      ),
      body: data.isEmpty
          ? const Center(
        child: Text(
          'No forecast data found',
          style: TextStyle(fontSize: 16),
        ),
      )
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.15),
              Theme.of(context).colorScheme.secondary.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'Temperature Variation',
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                legend: Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: true),

                primaryXAxis: CategoryAxis(
                  labelRotation: 70,
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: const TextStyle(fontSize: 10),
                ),

                /// 🔧 FIXED: ChartSeries → CartesianSeries
                series: <CartesianSeries<ForecastItem, String>>[
                  LineSeries<ForecastItem, String>(
                    dataSource: data,
                    xValueMapper: (d, _) =>
                    "${d.date.month}/${d.date.day} ${d.date.hour}:00",
                    yValueMapper: (d, _) => d.temp,
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 8,
                      width: 8,
                      shape: DataMarkerType.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
