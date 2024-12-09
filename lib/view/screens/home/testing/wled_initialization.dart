import 'package:car_wash_light/constants/app_colors.dart';
import 'package:car_wash_light/controllers/light_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddingLight extends StatelessWidget {
  final String groupName;
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lightNameController = TextEditingController();

  AddingLight({Key? key, required this.groupName}) : super(key: key);

  // Define MQTT Broker and User Credentials (hardcoded)
  final String mqttBroker = 'your_mqtt_broker';
  final String mqttUser = 'your_mqtt_username';
  final String mqttPass = 'your_mqtt_password';
  final String mqttClientID = 'your_mqtt_client_id';

  // Function to send WiFi and MQTT credentials to WLED device
  void _sendWiFiAndMqttCredentials(String ssid, String wifiPassword, String mqttTopic) async {
    final String url = 'http://4.3.2.1/json';  // WLED AP IP address

    Map<String, dynamic> data = {
      'nw': {
        'ins': [
          {
            'ssid': ssid,
            'psk': wifiPassword,
            'ip': [0, 0, 0, 0],  // Optional
            'gw': [0, 0, 0, 0],  // Optional
            'sn': [0, 0, 0, 0]   // Optional
          }
        ]
      },
      'mqtt': {
        'en': true,
        'broker': mqttBroker,
        'port': 1883,
        'user': mqttUser,
        'psk': mqttPass,
        'cid': mqttClientID,
        'topics': {
          'device': mqttTopic,
          'group': ''
        },
        'rtn': false  // Optional
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Credentials sent successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to send credentials: ${response.reasonPhrase}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void createLightNode(String lightName, String reference) {
    final DatabaseReference database = FirebaseDatabase.instance.ref();

    Map<String, dynamic> lightData = {
      "brightness": "00",
      "color": "eff",
      "name": lightName,
      "state": "off"
    };

    database.child(reference).set(lightData).then((_) {
      print('Light node created successfully at $reference');
    }).catchError((error) {
      print('Failed to create light node: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final LightController light = Get.find<LightController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: const Text(
          "Adding a Light",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField("SSID", Icons.wifi, ssidController),
            const SizedBox(height: 20),
            _buildTextField("Password", Icons.lock, passwordController, isPassword: true),
            const SizedBox(height: 20),
            _buildTextField("Light Name (MQTT Topic)", Icons.lightbulb_outline, lightNameController),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Send WiFi and MQTT credentials when the button is pressed
                _sendWiFiAndMqttCredentials(
                  ssidController.text,
                  passwordController.text,
                  lightNameController.text
                );

                light.updateLightReference(lightNameController.text);
                createLightNode(lightNameController.text, light.completeRefrence.value);

                ssidController.clear();
                passwordController.clear();
                lightNameController.clear();

                Get.snackbar(
                  "Success",
                  "Light added successfully",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: darkGreen,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Add Light",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: darkGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
