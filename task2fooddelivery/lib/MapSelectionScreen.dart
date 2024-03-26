import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:task2fooddelivery/ResultScreen.dart';

class MapSelectionScreen extends StatefulWidget {
  final int deliveryPersonAge;
  final int typeOfOrder;
  final int typeOfVehicle;
  final LatLng restaurantLocation;
  final LatLng userLocation;

  const MapSelectionScreen({
    Key? key,
    required this.deliveryPersonAge,
    required this.typeOfOrder,
    required this.typeOfVehicle,
    required this.restaurantLocation,
    required this.userLocation,
  }) : super(key: key);

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng _selectedRestaurantLocation = LatLng(0, 0);
  LatLng _selectedUserLocation = LatLng(0, 0);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRestaurantLocation = widget.restaurantLocation;
    _selectedUserLocation = widget.userLocation;
  }

  void _setRestaurantLocation(LatLng location) {
    setState(() {
      _selectedRestaurantLocation = location;
    });
  }

  void _setUserLocation(LatLng location) {
    setState(() {
      _selectedUserLocation = location;
    });
  }

  Future<double> getPrediction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'Delivery_person_Age': widget.deliveryPersonAge,
        'Type_of_order': widget.typeOfOrder,
        'Type_of_vehicle': widget.typeOfVehicle,
        'Restaurant_latitude': _selectedRestaurantLocation.latitude,
        'Restaurant_longitude': _selectedRestaurantLocation.longitude,
        'Delivery_location_latitude': _selectedUserLocation.latitude,
        'Delivery_location_longitude': _selectedUserLocation.longitude,
      };

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/predict'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        return result['prediction'];
      } else {
        throw Exception('Failed to get prediction');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Locations'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(0, 0),
                zoom: 15.0,
                onTap: (tapPosition, latLng) {
                  // Convert the TapPosition to a LatLng object
                  LatLng tappedLatLng = latLng as LatLng;

                  // Determine which location to set based on which one is currently being selected
                  if (_selectedRestaurantLocation.latitude== 0 && _selectedRestaurantLocation.longitude == 0) {
                    _setRestaurantLocation(tappedLatLng);
                  } else {
                    _setUserLocation(tappedLatLng);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedRestaurantLocation,
                      child:
                          Icon(Icons.restaurant, color: Colors.red),
                    ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedUserLocation,
                      child:  Icon(Icons.person_pin, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              double prediction = await getPrediction();
              print("the prediction is $prediction");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(prediction: prediction),
                ),
              );
            },
            child: Text('Get Prediction'),
          ),
        ],
      ),
    );
  }
}
