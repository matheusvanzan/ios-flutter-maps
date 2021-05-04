import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';

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
    print('Info dispositivo');
    print('Flutter');


    print('Canal iOS');


    print('Canal Android');
  }

  @override
  void initState() {
    super.initState();
    this.getDeviceInfo();
    
    // Código para atualizar a localização ao se mover
    // location.onLocationChanged.listen((LocationData loc) {
    //   setState(() {
    //     _locationData = loc;
    //   });
    // });

    // poderia usar um canal para obter a localização

    location.getLocation()
    .then((LocationData loc) {
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
                width: 80.0,
                height: 80.0,
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

