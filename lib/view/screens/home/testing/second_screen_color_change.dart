// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';

// class SecondScreenColorChange extends StatefulWidget {
//   const SecondScreenColorChange({Key? key}) : super(key: key);

//   @override
//   _SecondScreenColorChangeState createState() =>
//       _SecondScreenColorChangeState();
// }

// class _SecondScreenColorChangeState extends State<SecondScreenColorChange> {
//   Color currentColor = Colors.blue;
//   Timer? _debounce;

//   void changeColor(Color color) {
//     if (mounted) {
//       setState(() {
//         currentColor = color;
//       });

//       if (_debounce?.isActive ?? false) _debounce!.cancel();
//       _debounce = Timer(const Duration(milliseconds: 500), () {
//         _sendColorToAPI(color);
//       });
//     }
//   }

//   Future<void> callLedApi(int red, int green, int blue) async {
//     final String url = 'http://192.168.137.239/win&R=$red&G=$green&B=$blue';

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         print('API called successfully: ${response.body}');
//       } else {
//         print('Failed to call API: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error calling API: $e');
//     }
//   }

//   Future<void> _sendColorToAPI(Color color) async {
//     final String url =
//         'http://192.168.137.239/win?R=${color.red}&G=${color.green}&B=${color.blue}';

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Accept': 'application/json'},
//       ).timeout(
//         const Duration(seconds: 5),
//         onTimeout: () {
//           throw TimeoutException('Request timed out');
//         },
//       );

//       if (response.statusCode == 200) {
//         //HERE IS WHAT WE SHOULD HAVE TO CALL A METHOD OR API
//         _sendColorToAPI(currentColor);
//         callLedApi(currentColor.red, currentColor.green, currentColor.blue);
//         print('Color sent successfully');
//       } else {
//         print('Failed to send color. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending color: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating color: $e')),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Color Wheel'),
//         backgroundColor: currentColor,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               ColorPicker(
//                 pickerColor: currentColor,
//                 onColorChanged: changeColor,
//                 colorPickerWidth: 300,
//                 pickerAreaHeightPercent: 0.7,
//                 enableAlpha: false,
//                 displayThumbColor: true,
//                 paletteType: PaletteType.hueWheel,
//                 labelTypes: const [],
//                 portraitOnly: true,
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   'Selected Color: RGB(${currentColor.red}, ${currentColor.green}, ${currentColor.blue})',
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _sendColorToAPI(currentColor);
//                   callLedApi(
//                       currentColor.red, currentColor.green, currentColor.blue);
//                 },
//                 child: const Text('Refresh Color'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';

// class SecondScreenColorChange extends StatefulWidget {
//   const SecondScreenColorChange({Key? key}) : super(key: key);

//   @override
//   _SecondScreenColorChangeState createState() =>
//       _SecondScreenColorChangeState();
// }

// class _SecondScreenColorChangeState extends State<SecondScreenColorChange> {
//   Color currentColor = Colors.blue;
//   Timer? _debounce;

//   void changeColor(Color color) {
//     setState(() {
//       currentColor = color;
//     });

//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       _sendColorToAPI(color);
//     });
//   }

//   Future<void> _sendColorToAPI(Color color) async {
//     final String url =
//         'http://192.168.137.239/win?R=${color.red}&G=${color.green}&B=${color.blue}';

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Accept': 'application/json'},
//       ).timeout(
//         const Duration(seconds: 5),
//         onTimeout: () {
//           throw TimeoutException('Request timed out');
//         },
//       );

//       if (response.statusCode == 200) {
//         print(
//             'Color sent successfully: RGB(${color.red}, ${color.green}, ${color.blue})');
//       } else {
//         print('Failed to send color. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending color: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating color: $e')),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Color Wheel'),
//         backgroundColor: currentColor,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               ColorPicker(
//                 pickerColor: currentColor,
//                 onColorChanged: changeColor,
//                 colorPickerWidth: 300,
//                 pickerAreaHeightPercent: 0.7,
//                 enableAlpha: false,
//                 displayThumbColor: true,
//                 paletteType: PaletteType.hueWheel,
//                 labelTypes: const [],
//                 portraitOnly: true,
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   'Selected Color: RGB(${currentColor.red}, ${currentColor.green}, ${currentColor.blue})',
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:car_wash_light/controllers/light_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:multicast_dns/multicast_dns.dart';

// class SecondScreenColorChange extends StatefulWidget {
//   const SecondScreenColorChange({Key? key}) : super(key: key);

//   @override
//   _SecondScreenColorChangeState createState() =>
//       _SecondScreenColorChangeState();
// }

// class _SecondScreenColorChangeState extends State<SecondScreenColorChange> {
//   Color currentColor = Colors.blue;
//   Timer? _debounce;
//   LightController light = Get.find<LightController>();
//   bool _isLoading = false;
//   String? _ipAddress;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeIpAddress();
//   }

//   void _showToast(String message, {bool isError = false}) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: isError ? Colors.red : Colors.green,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   Future<void> _initializeIpAddress() async {
//     setState(() => _isLoading = true);
//     try {
//       _ipAddress = await _resolveIpAddress();
//       if (_ipAddress != null) {
//         _showToast('Device connected successfully');
//         setState(() => _isInitialized = true);
//       } else {
//         _showToast('Failed to connect to device', isError: true);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void changeColor(Color color) {
//     if (mounted) {
//       setState(() {
//         currentColor = color;
//       });

//       if (_debounce?.isActive ?? false) _debounce!.cancel();

//       _debounce = Timer(const Duration(milliseconds: 500), () {
//         _sendColorToAPI(color);
//       });
//     }
//   }

//   Future<String?> _resolveIpAddress() async {
//     try {
//       // Try direct mdnsToIpaddress first
//       try {
//         String ipAddress = await mdnsToIpaddress();
//         if (ipAddress.isNotEmpty) {
//           print('Resolved IP using mdnsToIpaddress: $ipAddress');
//           return ipAddress;
//         }
//       } catch (e) {
//         print('mdnsToIpaddress failed, trying backup method: $e');
//       }

//       // Fallback to resolveMdnsToIp
//       String? ip = await resolveMdnsToIp(light.mdns.value);
//       if (ip != null && ip.isNotEmpty) {
//         print('Resolved IP using resolveMdnsToIp: $ip');
//         return ip;
//       }

//       throw Exception('Failed to resolve IP address');
//     } catch (e) {
//       print('Error resolving IP: $e');
//       return null;
//     }
//   }

//   Future<String?> resolveMdnsToIp(String serviceName) async {
//     final MDnsClient client = MDnsClient();

//     try {
//       await client.start();

//       // Try direct IPv4 lookup first
//       await for (final IPAddressResourceRecord ip
//           in client.lookup<IPAddressResourceRecord>(
//               ResourceRecordQuery.addressIPv4(serviceName))) {
//         return ip.address.address;
//       }

//       // If direct lookup fails, try PTR/SRV method
//       await for (final PtrResourceRecord ptr
//           in client.lookup<PtrResourceRecord>(
//               ResourceRecordQuery.serverPointer(serviceName))) {
//         await for (final SrvResourceRecord srv
//             in client.lookup<SrvResourceRecord>(
//                 ResourceRecordQuery.service(ptr.domainName))) {
//           await for (final IPAddressResourceRecord ip
//               in client.lookup<IPAddressResourceRecord>(
//                   ResourceRecordQuery.addressIPv4(srv.target))) {
//             return ip.address.address;
//           }
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error in resolveMdnsToIp: $e');
//       return null;
//     } finally {
//       client.stop();
//     }
//   }

//   Future<String> mdnsToIpaddress() async {
//     // const String name = "wled-1.local";
//     final String name = light.mdns.string + '.local';

//     final MDnsClient client = MDnsClient();
//     String ipAddress = '';

//     try {
//       await client.start();

//       await for (final IPAddressResourceRecord ip
//           in client.lookup<IPAddressResourceRecord>(
//               ResourceRecordQuery.addressIPv4(name))) {
//         ipAddress = ip.address.address;
//         break;
//       }

//       if (ipAddress.isEmpty) {
//         throw Exception('Could not resolve IP address for $name');
//       }

//       return ipAddress;
//     } finally {
//       client.stop();
//     }
//   }

//   Future<void> callLedApi(int red, int green, int blue) async {
//     if (_ipAddress == null) {
//       _showToast('Device not connected', isError: true);
//       return;
//     }

//     final String url = 'http://$_ipAddress/win&R=$red&G=$green&B=$blue';

//     try {
//       final response =
//           await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

//       if (response.statusCode == 200) {
//         _showToast('Color updated successfully');
//       } else {
//         throw Exception('Failed to update color: ${response.statusCode}');
//       }
//     } catch (e) {
//       _showToast('Error updating LED color: ${e.toString()}', isError: true);
//     }
//   }

//   Future<void> _sendColorToAPI(Color color) async {
//     if (_isLoading || !_isInitialized || _ipAddress == null) {
//       _showToast('Device not ready', isError: true);
//       return;
//     }

//     final String url =
//         'http://$_ipAddress/win?R=${color.red}&G=${color.green}&B=${color.blue}';

//     try {
//       setState(() => _isLoading = true);

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Accept': 'application/json'},
//       ).timeout(const Duration(seconds: 5));

//       if (response.statusCode == 200) {
//         await callLedApi(color.red, color.green, color.blue);
//       } else {
//         throw Exception('Failed to send color: ${response.statusCode}');
//       }
//     } catch (e) {
//       _showToast('Error sending color: ${e.toString()}', isError: true);
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Color Wheel'),
//         backgroundColor: currentColor,
//         actions: [
//           // Add a refresh button to manually retry IP resolution if needed
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _isLoading ? null : _initializeIpAddress,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           if (!_isInitialized && !_isLoading)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Failed to connect to device'),
//                   ElevatedButton(
//                     onPressed: _initializeIpAddress,
//                     child: const Text('Retry Connection'),
//                   ),
//                 ],
//               ),
//             ),
//           if (_isInitialized)
//             SafeArea(
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 20),
//                     ColorPicker(
//                       pickerColor: currentColor,
//                       onColorChanged: changeColor,
//                       colorPickerWidth: 300,
//                       pickerAreaHeightPercent: 0.7,
//                       enableAlpha: false,
//                       displayThumbColor: true,
//                       paletteType: PaletteType.hueWheel,
//                       labelTypes: const [],
//                       portraitOnly: true,
//                     ),
//                     const SizedBox(height: 20),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Selected Color: RGB(${currentColor.red}, ${currentColor.green}, ${currentColor.blue})',
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Connected to: $_ipAddress',
//                             style: const TextStyle(
//                                 fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.3),
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:car_wash_light/controllers/light_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';

class SecondScreenColorChange extends StatefulWidget {
  const SecondScreenColorChange({Key? key}) : super(key: key);

  @override
  _SecondScreenColorChangeState createState() =>
      _SecondScreenColorChangeState();
}

class _SecondScreenColorChangeState extends State<SecondScreenColorChange> {
  Color currentColor = Colors.blue;
  Timer? _debounce;
  LightController light = Get.find<LightController>();
  bool _isLoading = false;
  String? _ipAddress;
  bool _isInitialized = false;
  final int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initializeIpAddress();
  }

  void _showToast(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _initializeIpAddress() async {
    setState(() => _isLoading = true);
    try {
      for (int i = 0; i < _maxRetries; i++) {
        _ipAddress = await _resolveIpAddress();
        if (_ipAddress != null) {
          _showToast('Device connected successfully');
          setState(() => _isInitialized = true);
          return;
        }
        // Wait before retry
        if (i < _maxRetries - 1) {
          await Future.delayed(const Duration(seconds: 1));
        }
      }
      _showToast('Failed to connect to device', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String?> _resolveIpAddress() async {
    try {
      final String deviceName = light.mdns.value.trim();
      if (deviceName.isEmpty) {
        throw Exception('Device name is empty');
      }

      // Ensure the device name ends with .local
      final String fullName =
          deviceName.endsWith('.local') ? deviceName : '$deviceName.local';

      print('Attempting to resolve: $fullName');

      final MDnsClient client = MDnsClient();
      await client.start();

      try {
        // First attempt: Direct IPv4 lookup
        await for (final IPAddressResourceRecord record
            in client.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(fullName))) {
          final String ip = record.address.address;
          print('Found IP address: $ip');
          return ip;
        }

        // Second attempt: Try looking up service
        final String serviceQuery = '_http._tcp.local';
        await for (final PtrResourceRecord ptr
            in client.lookup<PtrResourceRecord>(
                ResourceRecordQuery.serverPointer(serviceQuery))) {
          if (ptr.domainName.toLowerCase().contains(deviceName.toLowerCase())) {
            await for (final SrvResourceRecord srv
                in client.lookup<SrvResourceRecord>(
                    ResourceRecordQuery.service(ptr.domainName))) {
              await for (final IPAddressResourceRecord ip
                  in client.lookup<IPAddressResourceRecord>(
                      ResourceRecordQuery.addressIPv4(srv.target))) {
                final String resolvedIp = ip.address.address;
                print('Found IP through service discovery: $resolvedIp');
                return resolvedIp;
              }
            }
          }
        }

        print('No IP address found for $fullName');
        return null;
      } finally {
        client.stop();
      }
    } catch (e) {
      print('Error in _resolveIpAddress: $e');
      return null;
    }
  }

  void changeColor(Color color) {
    if (mounted) {
      setState(() {
        currentColor = color;
      });

      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        _sendColorToAPI(color);
      });
    }
  }

  Future<void> callLedApi(int red, int green, int blue) async {
    if (_ipAddress == null) {
      _showToast('Device not connected', isError: true);
      return;
    }

    final String url = 'http://$_ipAddress/win&R=$red&G=$green&B=$blue';

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _showToast('Color updated successfully');
      } else {
        throw Exception('Failed to update color: ${response.statusCode}');
      }
    } catch (e) {
      _showToast('Error updating LED color: ${e.toString()}', isError: true);
    }
  }

  Future<void> _sendColorToAPI(Color color) async {
    if (_isLoading || !_isInitialized || _ipAddress == null) {
      _showToast('Device not ready', isError: true);
      return;
    }

    final String url =
        'http://$_ipAddress/win?R=${color.red}&G=${color.green}&B=${color.blue}';

    try {
      setState(() => _isLoading = true);

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        await callLedApi(color.red, color.green, color.blue);
      } else {
        throw Exception('Failed to send color: ${response.statusCode}');
      }
    } catch (e) {
      _showToast('Error sending color: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Wheel'),
        backgroundColor: currentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _initializeIpAddress,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_isInitialized && !_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to connect to device'),
                  ElevatedButton(
                    onPressed: _initializeIpAddress,
                    child: const Text('Retry Connection'),
                  ),
                ],
              ),
            ),
          if (_isInitialized)
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ColorPicker(
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                      colorPickerWidth: 300,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: false,
                      displayThumbColor: true,
                      paletteType: PaletteType.hueWheel,
                      labelTypes: const [],
                      portraitOnly: true,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Selected Color: RGB(${currentColor.red}, ${currentColor.green}, ${currentColor.blue})',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Connected to: $_ipAddress',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
