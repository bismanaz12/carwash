import 'package:car_wash_light/view/screens/home/testing/adding_light.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Mqtt extends StatefulWidget {
  final String groupName;
  const Mqtt({super.key, required this.groupName});

  @override
  State<Mqtt> createState() => _MqttState();
}

class _MqttState extends State<Mqtt> {
  bool _isMqttLoading = false;

  Future<void> postMQTTSettings() async {
    setState(() {
      _isMqttLoading = true;
    });

    // Updated URL format with proper IP formatting
    final String apiUrl =
        'http://4.3.2.1:80/settings/sync'; // Added port 80 explicitly
    final Map<String, dynamic> requestBody = {
      'MQ': true,
      'MS': 'mqtt-dashboard.com',
      'MQPORT': '8884',
      'MQUSER': '',
      'MQPASS': '',
      'MQCID': 'juMmiN248h',
      'MD': 'testtopic/1',
      'MG': '',
    };

    try {
      // Validate URL before making the request
      final uri = Uri.parse(apiUrl);
      if (!uri.isAbsolute) {
        throw Exception('Invalid URL format');
      }

      // Add timeout to the request
      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'MQTT settings updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        print('MQTT settings updated successfully');
      } else {
        throw Exception(
            'Server returned status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      print('Detailed error: ${e.toString()}'); // More detailed error logging
      Get.snackbar(
        'Error',
        'Failed to update MQTT settings. Please check your connection and try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      setState(() {
        _isMqttLoading = false;
      });
    }
  }

  //CALLING THE COLOR CHANGING FUNCTION
  Future<void> callLedApi(int red, int green, int blue) async {
    final String url = 'http://4.3.2.1/win&R=$red&G=$green&B=$blue';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('API called successfully: ${response.body}');
      } else {
        print('Failed to call API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isMqttLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  // await postMQTTSettings();
                  // Only navigate if MQTT settings were successfully updated
                  await callLedApi(0, 255, 0);

                  Get.to(() => AddingLight(groupName: widget.groupName));
                  // if (!_isMqttLoading) {}
                },
                child: const Text('Update MQTT Settings'),
              ),
      ),
    );
  }
}
