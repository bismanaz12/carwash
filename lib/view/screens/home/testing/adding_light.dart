// // import 'package:car_wash_light/constants/app_colors.dart';
// // import 'package:car_wash_light/controllers/light_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:firebase_database/firebase_database.dart';

// // class AddingLight extends StatelessWidget {
// //   final String groupName;

// //   AddingLight({Key? key, required this.groupName}) : super(key: key);

// //   final TextEditingController ssidController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final TextEditingController lightNameController = TextEditingController();

// //   void createLightNode(String lightName, String reference) {
// //     final DatabaseReference database = FirebaseDatabase.instance.ref();

// //     Map<String, dynamic> lightData = {
// //       "brightness": "00",
// //       "color": "eff",
// //       "name": lightName,
// //       "state": "off"
// //     };

// //     database.child(reference).set(lightData).then((_) {
// //       print('Light node created successfully at $reference');
// //     }).catchError((error) {
// //       print('Failed to create light node: $error');
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final LightController light = Get.find<LightController>();

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: darkGreen,
// //         title: const Text(
// //           "Adding a Light",
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         centerTitle: true,
// //         iconTheme: const IconThemeData(
// //           color: Colors.white,
// //         ),
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [darkGreen.withOpacity(0.8), Colors.white],
// //           ),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               _buildTextField("SSID", Icons.wifi, ssidController),
// //               const SizedBox(height: 20),
// //               _buildTextField("Password", Icons.lock, passwordController,
// //                   isPassword: true),
// //               const SizedBox(height: 20),
// //               _buildTextField(
// //                   "Light Name", Icons.lightbulb_outline, lightNameController),
// //               const SizedBox(height: 40),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   light.updateLightReference(lightNameController.text);

// //                   print(
// //                       "SHAHYK JAHAN THE COMPLETE REFERENCE IS ${light.completeRefrence}");

// //                   // Create the light node in Firebase
// //                   createLightNode(
// //                       lightNameController.text, light.completeRefrence.value);

// //                   print("SSID: ${ssidController.text}");
// //                   print("Password: ${passwordController.text}");
// //                   print("Light Name: ${lightNameController.text}");

// //                   // Here you might want to add logic to connect the light to WiFi
// //                   // light.connectLightToWiFi(ssidController.text, passwordController.text);

// //                   // Clear the text fields after adding the light
// //                   ssidController.clear();
// //                   passwordController.clear();
// //                   lightNameController.clear();

// //                   // Show a success message to the user
// //                   Get.snackbar(
// //                     "Success",
// //                     "Light added successfully",
// //                     backgroundColor: Colors.green,
// //                     colorText: Colors.white,
// //                   );
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   foregroundColor: Colors.white,
// //                   backgroundColor: darkGreen,
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(30),
// //                   ),
// //                 ),
// //                 child: const Text(
// //                   "Add Light",
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTextField(
// //       String label, IconData icon, TextEditingController controller,
// //       {bool isPassword = false}) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.2),
// //             spreadRadius: 2,
// //             blurRadius: 5,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: TextField(
// //         controller: controller,
// //         obscureText: isPassword,
// //         decoration: InputDecoration(
// //           labelText: label,
// //           prefixIcon: Icon(icon, color: darkGreen),
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10),
// //             borderSide: BorderSide.none,
// //           ),
// //           filled: true,
// //           fillColor: Colors.white,
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:car_wash_light/constants/app_colors.dart';
// import 'package:car_wash_light/controllers/light_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AddingLight extends StatelessWidget {
//   final String groupName;
//   final TextEditingController ssidController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController lightNameController = TextEditingController();

//   AddingLight({Key? key, required this.groupName}) : super(key: key);

//   // Define MQTT Broker and User Credentials (hardcoded)
//   final String mqttBroker = 'your_mqtt_broker';
//   final String mqttUser = 'your_mqtt_username';
//   final String mqttPass = 'your_mqtt_password';
//   final String mqttClientID = 'your_mqtt_client_id';

//   // Function to send WiFi and MQTT credentials to WLED device
//   void _sendWiFiAndMqttCredentials(
//       String ssid, String wifiPassword, String mqttTopic) async {
//     final String url = 'http://192.168.4.1/json'; // WLED AP IP address

//     Map<String, dynamic> data = {
//       'nw': {
//         'ins': [
//           {
//             'ssid': ssid,
//             'psk': wifiPassword,
//             'ip': [0, 0, 0, 0], // Optional
//             'gw': [0, 0, 0, 0], // Optional
//             'sn': [0, 0, 0, 0] // Optional
//           }
//         ]
//       },
//       'mqtt': {
//         'en': true,
//         'broker': mqttBroker,
//         'port': 1883,
//         'user': mqttUser,
//         'psk': mqttPass,
//         'cid': mqttClientID,
//         'topics': {'device': mqttTopic, 'group': ''},
//         'rtn': false // Optional
//       }
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Credentials sent successfully",
//             backgroundColor: Colors.green, colorText: Colors.white);
//       } else {
//         print("SHAHYK ERROR");
//         Get.snackbar(
//             "Error", "Failed to send credentials: ${response.reasonPhrase}",
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       print(e.toString());
//       Get.snackbar("Error", "An error occurred: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     }
//   }

//   void createLightNode(String lightName, String reference) {
//     final DatabaseReference database = FirebaseDatabase.instance.ref();

//     Map<String, dynamic> lightData = {
//       "brightness": "00",
//       "color": "eff",
//       "name": lightName,
//       "state": "off"
//     };

//     database.child(reference).set(lightData).then((_) {
//       print('Light node created successfully at $reference');
//     }).catchError((error) {
//       print('Failed to create light node: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final LightController light = Get.find<LightController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: darkGreen,
//         title: const Text(
//           "Adding a Light",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildTextField("SSID", Icons.wifi, ssidController),
//             const SizedBox(height: 20),
//             _buildTextField("Password", Icons.lock, passwordController,
//                 isPassword: true),
//             const SizedBox(height: 20),
//             _buildTextField("Light Name (MQTT Topic)", Icons.lightbulb_outline,
//                 lightNameController),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 // Send WiFi and MQTT credentials when the button is pressed
//                 _sendWiFiAndMqttCredentials(ssidController.text,
//                     passwordController.text, lightNameController.text);

//                 light.updateLightReference(lightNameController.text);
//                 createLightNode(
//                     lightNameController.text, light.completeRefrence.value);

//                 ssidController.clear();
//                 passwordController.clear();
//                 lightNameController.clear();

//                 Get.snackbar(
//                   "Success",
//                   "Light added successfully",
//                   backgroundColor: Colors.green,
//                   colorText: Colors.white,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: darkGreen,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 "Add Light",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label, IconData icon, TextEditingController controller,
//       {bool isPassword = false}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: darkGreen),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// import 'package:car_wash_light/constants/app_colors.dart';
// import 'package:car_wash_light/controllers/light_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// class AddingLight extends StatelessWidget {
//   final String groupName;
//   final TextEditingController ssidController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController lightNameController = TextEditingController();

//   AddingLight({Key? key, required this.groupName}) : super(key: key);

//   // Define MQTT Broker and User Credentials (hardcoded)
//   final String mqttBroker = 'your_mqtt_broker';
//   final String mqttUser = 'your_mqtt_username';
//   final String mqttPass = 'your_mqtt_password';
//   final String mqttClientID = 'your_mqtt_client_id';

//   // Function to send WiFi and MQTT credentials to WLED device
//   Future<void> _sendWiFiAndMqttCredentials(
//       String ssid, String wifiPassword, String mqttTopic) async {
//     final String url =
//         'http://192.168.4.1/json'; // Update this to the correct WLED AP IP address

//     Map<String, dynamic> data = {
//       'nw': {
//         'ins': [
//           {
//             'ssid': ssid,
//             'psk': wifiPassword,
//             'ip': [0, 0, 0, 0], // Optional
//             'gw': [0, 0, 0, 0], // Optional
//             'sn': [0, 0, 0, 0] // Optional
//           }
//         ]
//       },
//       'mqtt': {
//         'en': true,
//         'broker': mqttBroker,
//         'port': 1883,
//         'user': mqttUser,
//         'psk': mqttPass,
//         'cid': mqttClientID,
//         'topics': {'device': mqttTopic, 'group': ''},
//         'rtn': false // Optional
//       }
//     };

//     final client = http.Client();
//     try {
//       final response = await client
//           .post(
//             Uri.parse(url),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode(data),
//           )
//           .timeout(
//               const Duration(seconds: 10)); // Increase timeout to 10 seconds

//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Credentials sent successfully",
//             backgroundColor: Colors.green, colorText: Colors.white);
//       } else {
//         Get.snackbar(
//             "Error", "Failed to send credentials: ${response.reasonPhrase}",
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } on TimeoutException catch (_) {
//       Get.snackbar("Error",
//           "Request timed out. Please check your connection and try again.",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } catch (e) {
//       print("Error sending credentials: ${e.toString()}");
//       Get.snackbar("Error", "An error occurred: $e",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       client.close();
//     }
//   }

//   Future<void> createLightNode(String lightName, String reference) async {
//     final DatabaseReference database = FirebaseDatabase.instance.ref();

//     Map<String, dynamic> lightData = {
//       "brightness": "00",
//       "color": "eff",
//       "name": lightName,
//       "state": "off"
//     };

//     try {
//       await database.child(reference).set(lightData);
//       print('Light node created successfully at $reference');
//     } catch (error) {
//       print('Failed to create light node: $error');
//       rethrow; // Rethrow the error to be handled by the caller
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final LightController light = Get.find<LightController>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: darkGreen,
//         title: const Text(
//           "Adding a Light",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildTextField("SSID", Icons.wifi, ssidController),
//             const SizedBox(height: 20),
//             _buildTextField("Password", Icons.lock, passwordController,
//                 isPassword: true),
//             const SizedBox(height: 20),
//             _buildTextField("Light Name (MQTT Topic)", Icons.lightbulb_outline,
//                 lightNameController),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () async {
//                 if (ssidController.text.isEmpty ||
//                     passwordController.text.isEmpty ||
//                     lightNameController.text.isEmpty) {
//                   Get.snackbar("Error", "Please fill in all fields",
//                       backgroundColor: Colors.red, colorText: Colors.white);
//                   return;
//                 }

//                 try {
//                   // Send WiFi and MQTT credentials
//                   await _sendWiFiAndMqttCredentials(ssidController.text,
//                       passwordController.text, lightNameController.text);

//                   // Update light reference and create light node
//                   light.updateLightReference(lightNameController.text);
//                   await createLightNode(
//                       lightNameController.text, light.completeRefrence.value);

//                   // Clear text fields
//                   ssidController.clear();
//                   passwordController.clear();
//                   lightNameController.clear();

//                   Get.snackbar(
//                     "Success",
//                     "Light added successfully",
//                     backgroundColor: Colors.green,
//                     colorText: Colors.white,
//                   );
//                 } catch (e) {
//                   print("Error adding light: ${e.toString()}");
//                   Get.snackbar(
//                     "Error",
//                     "Failed to add light. Please try again.",
//                     backgroundColor: Colors.red,
//                     colorText: Colors.white,
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: darkGreen,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 "Add Light",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       String label, IconData icon, TextEditingController controller,
//       {bool isPassword = false}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: darkGreen),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }
// adding_light.dart

import 'package:car_wash_light/controllers/light_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import './wifi_password_page.dart';

class WifiNetwork {
  final String ssid;
  final int rssi;

  WifiNetwork({required this.ssid, required this.rssi});

  factory WifiNetwork.fromJson(Map<String, dynamic> json) {
    return WifiNetwork(
      ssid: json['ssid'],
      rssi: json['rssi'],
    );
  }
}

class AddingLight extends StatefulWidget {
  final String groupName;
  const AddingLight({Key? key, required this.groupName}) : super(key: key);

  @override
  _AddingLightState createState() => _AddingLightState();
}

class AddingLightController extends GetxController {
  var networks = <WifiNetwork>[].obs;
  var isLoading = false.obs;

  Future<void> scanWifi() async {
    isLoading.value = true;

    try {
      final response = await http.get(Uri.parse('http://4.3.2.1/json/net'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<WifiNetwork> networksList = (jsonData['networks'] as List)
            .map((network) => WifiNetwork.fromJson(network))
            .toList();

        networks.value = networksList;
      } else {
        throw Exception('Failed to load WiFi networks');
      }
    } catch (e) {
      print('Error occurred while calling the API: $e');
      Get.snackbar(
        'Error',
        'Failed to scan WiFi networks',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToPasswordPage(String ssid, String groupName) {
    Get.to(
      () => WifiPasswordPage(
        ssid: ssid,
        groupName: groupName,
      ),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 300),
    );
  }
}

class _AddingLightState extends State<AddingLight> {
  final AddingLightController controller = Get.put(AddingLightController());
  final LightController light = Get.find<LightController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WLED WiFi Scanner'),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'First connect to the WLED-AP',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.scanWifi(),
              child: controller.isLoading.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text('Scan WiFi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => controller.networks.isEmpty
                  ? Center(child: Text('No networks found'))
                  : ListView.builder(
                      itemCount: controller.networks.length,
                      itemBuilder: (context, index) {
                        final network = controller.networks[index];
                        return Card(
                          elevation: 2,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Icon(Icons.wifi, color: Colors.blue[700]),
                            title: Text(network.ssid),
                            subtitle:
                                Text('Signal Strength: ${network.rssi} dBm'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              light.setSsid(network.ssid);

                              print(
                                  "SHAHYK JAHAN YOUR SSID IS ${network.ssid}");
                              controller.navigateToPasswordPage(
                                network.ssid,
                                widget.groupName,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
