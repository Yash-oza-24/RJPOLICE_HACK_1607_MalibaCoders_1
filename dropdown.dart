// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, library_private_types_in_public_api, unnecessary_new

import 'package:flutter/material.dart';
import 'package:mylogin3/views/Police/qrcode.dart';

class drop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(30, 107, 107, 107),
          title: Text(
            'State and District Dropdowns',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: StateDistrictDropdowns(),
      ),
    );
  }
}

class StateDistrictDropdowns extends StatefulWidget {
  @override
  _StateDistrictDropdownsState createState() => _StateDistrictDropdownsState();
}

class _StateDistrictDropdownsState extends State<StateDistrictDropdowns> {
  String selectedDistrict = "Jaipur";
  String selectedStation = "Jawahar Nagar Police Station";

  // Sample data for districts and stations
  List<String> districts = ['Jaipur', 'Udaypur', 'Ajmer'];
  Map<String, List<String>> stations = {
    'Jaipur': [
      "Jawahar Nagar Police Station",
      "Sadar Police Station",
      "Shyam Nagar Police Station",
      "Jyoti Nagar Police Station",
    ],
    'Udaypur': [
      'Dhanmandi Police Station',
      'Hathipol Police Station',
      'Hiran Magri Police Station'
    ],
    'Ajmer': [
      'Adarsh Nagar Police Station',
      'Ganj Police Station',
      'Kotwali Police Station'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // District Dropdown
            DropdownButton<String>(
              value: selectedDistrict,
              hint: Text('Select district'),
              items: districts.map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedDistrict = value!;
                  selectedStation = stations[value]![
                      0]; // Set the default station when district changes
                });
              },
            ),

            SizedBox(height: 20),

            // Station Dropdown
            DropdownButton<String>(
              value: selectedStation,
              hint: Text('Select station'),
              // ignore: unnecessary_null_comparison
              items: selectedDistrict == null
                  ? []
                  : stations[selectedDistrict]!.map((String station) {
                      return DropdownMenuItem<String>(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedStation = value!;
                });
              },
            ),

            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => qrcode(
                              value1: selectedDistrict,
                              value2: selectedStation)));
                },
                child: Text("Create qr")),
          ],
        ),
      ),
    );
  }
}
