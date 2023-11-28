import 'package:arttest/models/whether.dart';
import 'package:arttest/service/service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// Replace with your actual package path

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String location = '';

  Weather? _currentWeather; 
  final Webservice _webservice =
      Webservice();

  void getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permission is not Given");
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print("Latitude: " + currentPosition.latitude.toString());
      print("Longitude: " + currentPosition.longitude.toString());
      try {
        Weather weatherData = await _webservice.fetchWeatherData(
            currentPosition.latitude, currentPosition.longitude);
        setState(() {
          _currentWeather = weatherData;
          
        });
      } catch (e) {
        print('Error fetching weather data: $e');
      }
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
      Weather weatherData = await  _webservice.fetchWeatherDataByLocation(enteredLocation);
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
        
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    getWeatherForLocation(location);
              
                  },
                ),
              ),
              onChanged: (value) {
                location = value;
              },
            ),
            SizedBox(height: 20),

            Text(_currentWeather!.name.toString(),style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w600),),
            
            SizedBox(height: 20),
            // Weather information display area
            _currentWeather != null
                ? Container(
                    child: Column(
                      children: [
                        Text('Temperature: ${_currentWeather!.main!.temp.toString()}°C',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
                        //Text('Description: ${_currentWeather!.description}'),
                      ],
                    ),
                  )
                : Container(), // You can place loading indicators or error messages here
            SizedBox(height: 20),
            // ElevatedButton(
            //     onPressed: getCurrentPosition,
            //     child: Text("Get Latitude and Longitude")),
          ],
        ),
      ),
    );
  }
}
