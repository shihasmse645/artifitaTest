import 'package:arttest/service/service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Hivepage extends StatefulWidget {
  const Hivepage({super.key});

  @override
  State<Hivepage> createState() => _HivepageState();
}

class _HivepageState extends State<Hivepage> {
  final Webservice _webservice = Webservice();

  Box? box;
  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox("data");
    return;
  }

  // getAlldata() async {
  //   await openBox();
  //   _webservice.fetchWeatherData(latitude, longitude)
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
