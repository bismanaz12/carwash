import 'package:car_wash_light/constants/app_colors.dart';
import 'package:car_wash_light/controllers/auth_controller.dart';
import 'package:car_wash_light/controllers/list_lights_controller.dart';
import 'package:car_wash_light/view/screens/condition/testing_edit_list_of_lights.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfLights extends StatelessWidget {
  const ListOfLights({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final ListLightController light = Get.find<ListLightController>();

    // Update controller name when the widget is built
    light.updateControllerSection(auth.conId.value);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: const Text(
          "See list of all lights",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: light.fetchAllGroupsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Obx(() => ListView.builder(
                  itemCount: auth.groups.length,
                  itemBuilder: (context, index) {
                    final groupName = auth.groups[index];
                    return TestingEditListOfLights(groupName: groupName);
                  },
                ));
          }
        },
      ),
    );
  }
}
