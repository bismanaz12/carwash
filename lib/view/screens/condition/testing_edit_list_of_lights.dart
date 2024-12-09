import 'package:car_wash_light/constants/app_colors.dart';
import 'package:car_wash_light/controllers/list_lights_controller.dart';
import 'package:car_wash_light/model/led_model.dart';
import 'package:car_wash_light/view/screens/condition/testing_custom_color_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestingEditListOfLights extends StatelessWidget {
  final String groupName;

  const TestingEditListOfLights({Key? key, required this.groupName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ListLightController light = Get.find<ListLightController>();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kTertiaryColor.withOpacity(0.1), Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Group: $groupName",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTertiaryColor,
              ),
            ),
          ),
          GetBuilder<ListLightController>(
            builder: (controller) {
              final groupLights =
                  controller.lightForAllGroups[groupName] ?? <LedModel>[].obs;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: groupLights.length,
                itemBuilder: (context, index) {
                  final currentLight = groupLights[index];
                  return _buildLightCard(context, currentLight, controller);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLightCard(
      BuildContext context, LedModel currentLight, ListLightController light) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLight.id,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kTertiaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to control',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildToggleSwitch(currentLight, light),
              const SizedBox(width: 16),
              _buildColorButton(context, currentLight, light),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(LedModel currentLight, ListLightController light) {
    String compositeKey = '$groupName-${currentLight.id}';

    return Obx(() {
      bool isToggled = light.toggleStates[compositeKey] ?? false;
      return GestureDetector(
        onTap: () => light.toggleLight(groupName, currentLight.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 36,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isToggled ? Colors.green : Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: isToggled
                    ? Colors.green.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 2,
                left: isToggled ? 30 : 2,
                right: isToggled ? 2 : 30,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildColorButton(
      BuildContext context, LedModel currentLight, ListLightController light) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Color(
            int.parse(currentLight.color.substring(1), radix: 16) + 0xFF000000),
        radius: 24,
        child: IconButton(
          icon: const Icon(Icons.palette, color: Colors.white),
          onPressed: () => _showColorPicker(context, currentLight, light),
        ),
      ),
    );
  }

  void _showColorPicker(
      BuildContext context, LedModel currentLight, ListLightController light) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: TestingCustomColorSelection(
            ledId: currentLight.id,
            groupName: groupName,
            onColorSelected: (String colorValue) {
              light.updateLEDColor(groupName, currentLight.id, colorValue);
            },
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }
}
