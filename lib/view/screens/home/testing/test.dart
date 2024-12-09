import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class WifiScanWidget extends StatefulWidget {
  const WifiScanWidget({Key? key}) : super(key: key);

  @override
  _WifiScanWidgetState createState() => _WifiScanWidgetState();
}

class _WifiScanWidgetState extends State<WifiScanWidget> {
  List<WifiNetwork> _networks = [];
  bool _isLoading = false;

  Future<void> _scanWifi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://4.3.2.1/json/net'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<WifiNetwork> networks = (jsonData['networks'] as List)
            .map((network) => WifiNetwork.fromJson(network))
            .toList();

        setState(() {
          _networks = networks;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load WiFi networks');
      }
    } catch (e) {
      print('Error occurred while calling the API: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          ElevatedButton(
            onPressed: _isLoading ? null : _scanWifi,
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Scan WiFi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _networks.isEmpty
                ? Center(child: Text('No networks found'))
                : ListView.builder(
                    itemCount: _networks.length,
                    itemBuilder: (context, index) {
                      final network = _networks[index];
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
