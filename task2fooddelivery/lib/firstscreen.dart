import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:task2fooddelivery/MapSelectionScreen.dart';
class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController deliveryPersonAgeController = TextEditingController();
  TextEditingController deliveryPersonRatingsController = TextEditingController();
  TextEditingController typeOfOrderController = TextEditingController();
  TextEditingController typeOfVehicleController = TextEditingController();

  LatLng restaurantLocation = LatLng(0, 0); // Default restaurant location
  LatLng userLocation = LatLng(0, 0); // Default user location
  String typeOfOrderDropdownValue = '2'; // Set the default value for type of order dropdown
  String typeOfVehicleDropdownValue = '2'; // Set the default value for type of vehicle dropdown

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
      // Handle location fetching errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: deliveryPersonAgeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Delivery Person Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter delivery person age';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: typeOfOrderDropdownValue, // Set the default value for type of order dropdown
                onChanged: (String? newValue) {
                  setState(() {
                    typeOfOrderDropdownValue = newValue!;
                  });
                },
                items: {
                  'Snack': '3',
                  'Drinks': '1',
                  'Buffet': '0',
                  'Meal': '2',
                }.entries.map((MapEntry<String, String> entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
              ),

              DropdownButtonFormField<String>(
                value: typeOfVehicleDropdownValue, // Set the default value for type of vehicle dropdown
                onChanged: (String? newValue) {
                  setState(() {
                    typeOfVehicleDropdownValue = newValue!;
                  });
                },
                items: {
                  'Motorcycle': '2',
                  'Scooter': '3',
                  'Electric Scooter': '1',
                  'Bicycle': '0',
                }.entries.map((MapEntry<String, String> entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
              ),

              // Add other TextFormField widgets for collecting data

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigate to the map selection screen with the form data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapSelectionScreen(
                            deliveryPersonAge: int.parse(deliveryPersonAgeController.text),
                            typeOfOrder: int.parse(typeOfOrderDropdownValue),
                            typeOfVehicle: int.parse(typeOfVehicleDropdownValue),
                            restaurantLocation: restaurantLocation, // Pass default restaurant location
                            userLocation: userLocation, // Pass current user location
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
