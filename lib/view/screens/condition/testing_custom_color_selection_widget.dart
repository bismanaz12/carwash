import 'package:car_wash_light/controllers/list_lights_controller.dart';
import 'package:car_wash_light/model/led_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'dart:async';

class TestingCustomColorSelection extends StatefulWidget {
  final String ledId;
  final String groupName;
  final VoidCallback onClose;
  final Function(String) onColorSelected;

  const TestingCustomColorSelection({
    Key? key,
    required this.ledId,
    required this.groupName,
    required this.onClose,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  State<TestingCustomColorSelection> createState() =>
      _TestingCustomColorSelectionState();
}

class _TestingCustomColorSelectionState
    extends State<TestingCustomColorSelection> {
  late Color currentColor;
  final ListLightController lightController = Get.find();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Try to get the current color from the controller, or use a default color
    LedModel currentLed = lightController.lightForAllGroups[widget.groupName]
            ?.firstWhere((light) => light.id == widget.ledId,
                orElse: () => LedModel(
                    id: widget.ledId,
                    brightness: '00',
                    color: '#0000FF',
                    name: 'Unknown',
                    state: 'off')) ??
        LedModel(
            id: widget.ledId,
            brightness: '00',
            color: '#0000FF',
            name: 'Unknown',
            state: 'off');

    currentColor =
        Color(int.parse(currentLed.color.substring(1), radix: 16) + 0xFF000000);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _uploadColor();
    });
  }

  void _uploadColor() {
    String hexColor =
        '#${currentColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    print("Uploading color hex code: $hexColor");

    // Update LED color in Firebase
    lightController.updateLEDColor(widget.groupName, widget.ledId, hexColor);
    widget.onColorSelected(hexColor); // Call the callback function
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Color for ${widget.ledId}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ColorPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hueWheel,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Close'),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }
}
