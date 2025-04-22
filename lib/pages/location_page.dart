import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTracker extends StatefulWidget {
  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _phoneNumberController = TextEditingController();

  late Position _currentPosition;
  late Map<String, dynamic> _locationData = {};
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 17.0,
          ),
        ),
      );
    }

    _firestore.collection("locations").doc(_phoneNumberController.text).set({
      "latitude": _currentPosition.latitude,
      "longitude": _currentPosition.longitude,
      "timestamp": Timestamp.now(),
    });
  }

  void _searchLocation() async {
    final phoneNumber = _phoneNumberController.text;
    if (phoneNumber.isEmpty) {
      return;
    }

    final locationSnapshot =
        await _firestore.collection("locations").doc(phoneNumber).get();
    if (locationSnapshot.exists) {
      setState(() {
        _locationData = locationSnapshot.data() ?? {};
      });

      
      if (_mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(_locationData["latitude"], _locationData["longitude"]),
              zoom: 17.0,
            ),
          ),
        );
      }
    } else {
      _showLocationNotFoundDialog();
    }
  }

  void _showLocationNotFoundDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Not Found"),
          content: Text(
              "CANNOT FIND LOCATION TRY AGAIN LATER."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Tracker"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 200,
          ),
          ElevatedButton(
            child: Text("Search"),
            onPressed: _searchLocation,
          ),
          if (_locationData.isNotEmpty)
            Column(
              children: <Widget>[
                Text("Latitude: ${_locationData["latitude"]}"),
                Text("Longitude: ${_locationData["longitude"]}"),
                Text("Timestamp: ${_locationData["timestamp"].toDate()}"),
              ],
            )
          
          else if (_currentPosition != null)
            Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentPosition.latitude, _currentPosition.longitude),
                  zoom: 16.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  var _controller;
                  _controller.complete(controller);
                },
              ),
            )
          else
            Text("No location data found"),
        ],
      ),
    );
  }
}
