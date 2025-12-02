import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/providers/weather_provider.dart';
import 'src/utils/theme.dart';
import 'src/views/splash/splash_screen.dart';
import 'src/views/home/home_screen.dart';
import 'src/views/search/search_screen.dart';
import 'src/views/forecast/forecast_screen.dart';
import 'src/views/favorites/favorites_screen.dart';
import 'src/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>(Constants.hiveBoxFavorites); // stores city names
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final ThemeMode _default = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _default,
        initialRoute: SplashScreen.route,
        routes: {
          SplashScreen.route: (_) => const SplashScreen(),
          HomeScreen.route: (_) => const HomeScreen(),
          SearchScreen.route: (_) => const SearchScreen(),
          ForecastScreen.route: (_) => const ForecastScreen(),
          FavoritesScreen.route: (_) => const FavoritesScreen(),
        },
      ),
    );
  }
}
