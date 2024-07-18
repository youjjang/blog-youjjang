import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Geolocator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _latitude;
  String? _longitude;

  void _getCurrentLocation() async {
    try {
      Position position = await getCurrentLocation();

      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      setState(() {
        _latitude = '${position.latitude.toString()}';
        _longitude = '${position.longitude.toString()}';
      });
    } catch (e) {
      setState(() {
        _latitude = 'Error';
        _longitude = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Test Geolocation",
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Latitude : $_latitude', style: TextStyle(fontSize: 30)),
              SizedBox(height: 15),
              Text('Longitude : $_longitude', style: TextStyle(fontSize: 30)),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: _getCurrentLocation,
                  child: Text(
                    "Get Current Location",
                  )),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                },
                child: Text("Call Geolocator.openLocationSettings()"),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
                child: Text(
                  "Call Geolocator.openAppSettings()",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Position> getCurrentLocation() async {
  bool isPermissionGranted = await requestLocationPermission();
  if (isPermissionGranted) {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  } else {
    throw Exception("Location permission not granted");
  }
}

Future<bool> requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 위치 서비스 활성화 여부 확인
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 위치 서비스가 비활성화된 경우
    await Geolocator.openLocationSettings();
    return Future.value(false);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 권한이 거부된 경우
      return Future.value(false);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // 권한이 영구적으로 거부된 경우
    await Geolocator.openAppSettings();
    return Future.value(false);
  }

  // 권한이 허용된 경우
  return Future.value(true);
}
