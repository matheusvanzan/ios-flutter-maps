import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:device_info/device_info.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = new Location();
  LocationData _locationData;

  void getDeviceInfo() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((IosDeviceInfo iosInfo) {
        print('Dispositivo: ${iosInfo.utsname.machine}');
      });
    } else {
      deviceInfo.androidInfo.then((AndroidDeviceInfo androidInfo) {
        print('Dispositivo: ${androidInfo.model}');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getDeviceInfo();
    location.getLocation().then((LocationData loc) {
      setState(() {
        _locationData = loc;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapas Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlutterMap(
        options: new MapOptions(
          center: new LatLng(_locationData.latitude, _locationData.longitude),
          zoom: 13.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 50.0,
                height: 50.0,
                point: new LatLng(_locationData.latitude, _locationData.longitude),
                builder: (ctx) =>
                new Container(
                  child: new Image.network('https://www.jav.com.br/wp-content/uploads/2017/03/map-marker-icon.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}