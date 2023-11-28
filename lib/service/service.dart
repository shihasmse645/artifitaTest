import 'dart:convert';
import 'package:arttest/models/whether.dart';
import 'package:http/http.dart' as http;
class Webservice{
   //String apikey = "2e32d3ba66735f8f3f3aab1bdb675a40";
   Future<Weather> fetchWeatherData(double latitude, double longitude) async {
  const apiKey = '2e32d3ba66735f8f3f3aab1bdb675a40'; // Replace with your OpenWeatherMap API key
  final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return Weather.fromJson(jsonData);
  } else {
    throw Exception('Failed to load weather data');
  }
}
  Future<Weather> fetchWeatherDataByLocation(String location) async {
  const apiKey = '2e32d3ba66735f8f3f3aab1bdb675a40'; // Replace with your OpenWeatherMap API key

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}