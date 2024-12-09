import 'package:http/http.dart' as http;

Future<void> setupWLED(
    String wledIp, String ssid, String password, String mqttServer) async {
  // 1. Set WiFi credentials
  var wifiResponse = await http.post(
    Uri.parse('http://$wledIp/wifi'),
    body: {
      'ssid': ssid,
      'password': password,
    },
  );

  if (wifiResponse.statusCode == 200) {
    print('WiFi connected!');

    // 2. Set MQTT settings
    var mqttResponse = await http.post(
      Uri.parse('http://$wledIp/mqtt'),
      body: {
        'mqttServer': mqttServer,
        'mqttPort': '1883', // Default MQTT port
        'mqttUser': 'username', // Add actual username for your MQTT broker
        'mqttPass': 'password', // Add actual password for your MQTT broker
      },
    );

    if (mqttResponse.statusCode == 200) {
      print('MQTT settings saved!');
    } else {
      print('Failed to set MQTT.');
    }
  } else {
    print('WiFi setup failed.');
  }
}
