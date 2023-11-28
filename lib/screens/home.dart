import 'package:arttest/models/whether.dart';
import 'package:arttest/screens/hivepage.dart';
import 'package:arttest/service/service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String location = '';
  bool isCelsius = true;
  Weather? _currentWeather;
  final Webservice _webservice = Webservice();
  Box? box;
  List data = [];
  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox("data");
    return;
  }

  void getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // ignore: avoid_print
      print("Permission is not Given");
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print("Latitude: " + currentPosition.latitude.toString());
      print("Longitude: " + currentPosition.longitude.toString());
      try {
        await openBox();
        Weather weatherData = await _webservice.fetchWeatherData(
            currentPosition.latitude, currentPosition.longitude);
        await putData(weatherData);
        setState(() {
          _currentWeather = weatherData;
        });
      } catch (e) {
        print('Error fetching weather data: $e');
      }
      //get data from DB
      var mydata = box?.toMap().values.toList();
      if (mydata!.isEmpty) {
        data.add('empty');
      } else {
        data = mydata;
      }
    }
  }

  //insert data to DB
  Future putData(data) async {
    await box?.clear();
    for (var d in data) {
      box?.add(d);
    }
  }

  @override
  void initState() {
    getCurrentPosition();
    // TODO: implement initState
    super.initState();
  }

  void getWeatherForLocation(String enteredLocation) async {
    try {
      Weather weatherData =
          await _webservice.fetchWeatherDataByLocation(enteredLocation);
      setState(() {
        _currentWeather = weatherData;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    getWeatherForLocation(location);
                  },
                ),
              ),
              onChanged: (value) {
                location = value;
              },
            ),
            const SizedBox(height: 20),

            Text(
              _currentWeather!.name.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),
            // Weather information display area
            _currentWeather != null
                ? Container(
                    child: Column(
                      children: [
                        Text(
                            'Temperature: ${isCelsius ? _currentWeather!.main!.temp.toString() : _toFahrenheit(_currentWeather!.main!.temp!).toString()}°${isCelsius ? 'C' : 'F'}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        Text(
                            'Humidity: ${_currentWeather!.main!.humidity.toString()}°C',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        Text(
                            'Wind Speed: ${_currentWeather!.wind!.speed.toString()}°C',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        Text(
                            'Description: ${_currentWeather!.weather![0].description}°C',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),

                        //Text('Description: ${_currentWeather!.description}'),
                      ],
                    ),
                  )
                : Container(), // You can place loading indicators or error messages here
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '°C',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isCelsius,
                  onChanged: (value) {
                    setState(() {
                      isCelsius = value;
                    });
                  },
                ),
                const Text(
                  '°F',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Hivepage()));
                },
                child: Text("hive"))
          ],
        ),
      ),
    );
  }

  double _toFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }
}
