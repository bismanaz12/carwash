import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class FirstButtonScreen extends StatefulWidget {
  const FirstButtonScreen({Key? key}) : super(key: key);

  @override
  _FirstButtonScreenState createState() => _FirstButtonScreenState();
}

class _FirstButtonScreenState extends State<FirstButtonScreen> {
  Color currentColor = Colors.blue;
  Timer? _debounce;

  // Function to handle color change and debounce API call
  void changeColor(Color color) {
    if (mounted) {
      setState(() {
        currentColor = color; // Update UI with the color
      });

      // Debounce the API call
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      // Set a delay to call the API when scrolling stops
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _sendColorToAPI(color); // API is called only when user stops on a color
      });
    }
  }

  // Function to call LED API
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

  // Function to send selected color to the API
  Future<void> _sendColorToAPI(Color color) async {
    final String url =
        'http://4.3.2.1/win?R=${color.red}&G=${color.green}&B=${color.blue}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        callLedApi(color.red, color.green, color.blue); // Call LED API
        print('Color sent successfully');
      } else {
        print('Failed to send color. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending color: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating color: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel debounce timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Wheel'),
        backgroundColor: currentColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Color picker with onColorChanged calling changeColor function
              ColorPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor, // Use changeColor for debounce
                colorPickerWidth: 300,
                pickerAreaHeightPercent: 0.7,
                enableAlpha: false,
                displayThumbColor: true,
                paletteType: PaletteType.hueWheel,
                labelTypes: const [],
                portraitOnly: true,
              ),
              const SizedBox(height: 20),
              // Display selected color values
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Selected Color: RGB(${currentColor.red}, ${currentColor.green}, ${currentColor.blue})',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // Button to manually refresh and send color to API
              // ElevatedButton(
              //   onPressed: () {
              //     _sendColorToAPI(currentColor); // Send current color manually
              //   },
              //   child: const Text('Refresh Color'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
