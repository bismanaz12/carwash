import 'package:car_wash_light/view/screens/home/testing/second_screen_color_change.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './wifi_password_page.dart';
import 'package:car_wash_light/controllers/light_controller.dart';

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

class SecondButtonController extends GetxController {
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
        backgroundColor: Colors.red[700],
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
      duration: const Duration(milliseconds: 300),
    );
  }
}

class SecondButtonScreen extends StatelessWidget {
  SecondButtonScreen({Key? key}) : super(key: key);

  final SecondButtonController controller = Get.put(SecondButtonController());
  final LightController light = Get.find<LightController>();

  // Define dark green colors
  final Color darkGreen = const Color(0xFF006400);
  final Color lightGreen = const Color(0xFF90EE90);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WLED WiFi Scanner',
            style: TextStyle(color: Colors.white)),
        backgroundColor: darkGreen,
      ),
      body: Container(
        color: Colors.green[50], // Light green background
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'First connect to the WLED-AP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.scanWifi(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('Scan WiFi'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const SecondScreenColorChange());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Already connected?"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => controller.networks.isEmpty
                    ? Center(
                        child: Text('No networks found',
                            style: TextStyle(color: darkGreen)))
                    : ListView.builder(
                        itemCount: controller.networks.length,
                        itemBuilder: (context, index) {
                          final network = controller.networks[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            color: lightGreen,
                            child: ListTile(
                              leading: Icon(Icons.wifi, color: darkGreen),
                              title: Text(network.ssid,
                                  style: TextStyle(color: darkGreen)),
                              subtitle: Text(
                                  'Signal Strength: ${network.rssi} dBm',
                                  style: TextStyle(color: Colors.green[800])),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: darkGreen),
                              onTap: () {
                                light.setSsid(network.ssid);
                                print(
                                    "SHAHYK JAHAN YOUR SSID IS ${network.ssid}");
                                controller.navigateToPasswordPage(
                                  network.ssid,
                                  "DefaultGroup", // Replace with actual group name if available
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
      ),
    );
  }
}
