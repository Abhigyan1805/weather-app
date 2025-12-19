import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String city = "London";
  double? temperature;
  bool isLoading = false;
  String? error;

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final url =
          "https://api.open-meteo.com/v1/forecast?latitude=51.5072&longitude=-0.1276&current_weather=true";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data["current_weather"]["temperature"];
        });
      } else {
        error = "Failed to load weather data";
      }
    } catch (_) {
      error = "Network error";
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : error != null
                ? Text(error!)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        city,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        temperature != null
                            ? "$temperature °C"
                            : "No data",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchWeather,
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
      ),
    );
  }
}
