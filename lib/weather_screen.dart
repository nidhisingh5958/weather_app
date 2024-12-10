import "dart:convert";
import "dart:ui";
import "package:intl/intl.dart";
import 'package:weather_app/api.dart';

import "package:flutter/material.dart";
import "package:weather_app/additional_info_item.dart";
import "package:weather_app/hourly_forecast_item.dart";
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Noida";
      final res = await http.get(Uri.parse(
          "http://api.weatherapi.com/v1/current.json?key=$openWeatherAPIKey&q=$cityName&days=1"));

      final data = jsonDecode(res.body);

      // if (res.statusCode != 200) {
      //   throw "Failed to load weather data";
      // }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
            ),
          ],
        ),
        body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data;

            final currentWeather = data!["current"];
            final currentTemp = currentWeather["temp_c"];
            final currentSky = currentWeather["condition"]["text"];
            final currentIconUrl =
                "http:${currentWeather["condition"]["icon"]}";

            final windSpeed = currentWeather["wind_kph"];
            final humidity = currentWeather["humidity"];
            final visibility = currentWeather["vis_km"];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  currentTemp.toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Image.network(
                                  currentIconUrl,
                                  width: 60,
                                  height: 60,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //weather forecast card
                  const SizedBox(height: 15),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 0; i < 5; i++)
                  //         HourlyForecastItem(
                  //           icon: Icons.wb_sunny,
                  //           // data["forecast"]["forecastday"][0]["hour"]
                  //           // [i + 1]["condition"]["icon"],
                  //           time: currentWeather["last_updated"].toString(),
                  //           value: currentWeather["temp_c"].toString(),
                  //         )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(currentWeather["last_updated"]);
                        return HourlyForecastItem(
                          icon: Icons.wb_sunny,
                          time: DateFormat.Hm().format(time),
                          value: currentWeather["temp_c"].toString(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // additional information card

                  const Text(
                    'Additional Information ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.air,
                        title: 'Wind Speed',
                        value: windSpeed.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        title: 'Humidity',
                        value: humidity.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.visibility,
                        title: 'Visibility',
                        value: visibility.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
