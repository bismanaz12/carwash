import 'dart:async';
import 'package:car_wash_light/controllers/light_controller.dart';
import 'package:car_wash_light/view/screens/home/testing/second_screen_color_change.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WifiPasswordPage extends StatefulWidget {
  final String ssid;
  final String groupName;

  WifiPasswordPage({
    Key? key,
    required this.ssid,
    required this.groupName,
  }) : super(key: key);

  @override
  _WifiPasswordPageState createState() => _WifiPasswordPageState();
}

class _WifiPasswordPageState extends State<WifiPasswordPage> {
  final _passwordController = TextEditingController();
  final _mdnsController = TextEditingController();
  bool _isObscured = true;
  bool _isWifiLoading = false;
  final LightController light = Get.find<LightController>();

  Future<void> submitWifiCredentials() async {
    setState(() {
      _isWifiLoading = true;
    });

    try {
      print('Submitting WiFi credentials for SSID: ${widget.ssid}');
      var formData = {
        'CS': widget.ssid,
        'CP': _passwordController.text,
        'AB': "2",
        'CM': _mdnsController.text, // Added MDNS parameter
      };

      final response = await http.post(
        Uri.parse('http://4.3.2.1/settings/wifi'),
        body: formData,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        print('WiFi credentials submitted successfully');
        Get.snackbar(
          'Success',
          'WiFi credentials submitted. Connecting to network...',
          backgroundColor: Colors.green[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        light.setPassword(_passwordController.text);
        light.setMdns(_mdnsController.text); // Set MDNS in controller
      } else {
        throw Exception(
            'Failed to submit WiFi credentials: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in submitWifiCredentials: $e');
      Get.snackbar(
        'success',
        'CONNECTED SUCESSFULLY!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        _isWifiLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _mdnsController.dispose(); // Added disposal of MDNS controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect to ${widget.ssid}'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[200]!, Colors.green[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.wifi_lock,
                        size: 64,
                        color: Colors.green[700],
                      ),
                      SizedBox(height: 24),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          labelText: 'Enter WiFi Password',
                          labelStyle: TextStyle(color: Colors.green[700]),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[700]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.green[700],
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _mdnsController,
                        decoration: InputDecoration(
                          labelText: 'Enter MDNS Name',
                          labelStyle: TextStyle(color: Colors.green[700]),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[700]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_isWifiLoading) return;
                            await submitWifiCredentials();
                            light.setMdns(_mdnsController.text);
                            Get.to(() => const SecondScreenColorChange());
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isWifiLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text('Connect'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
