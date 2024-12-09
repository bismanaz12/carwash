import 'package:car_wash_light/constants/app_colors.dart';
import 'package:car_wash_light/controllers/auth_controller.dart';
import 'package:car_wash_light/controllers/light_controller.dart';
import 'package:car_wash_light/view/screens/condition/testing_edit.dart';
import 'package:car_wash_light/view/screens/home/Custom_Container_Tile_widget.dart';
import 'package:car_wash_light/view/screens/home/light_control.dart';
import 'package:car_wash_light/view/screens/home/testing/adding_light.dart';
import 'package:car_wash_light/view/screens/home/testing/mqtt.dart';
import 'package:car_wash_light/view/screens/home/testing/three_buttons_screen.dart';
import 'package:car_wash_light/view/widget/Home_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLights extends StatelessWidget {
  const AddLights({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController groupController = TextEditingController();
    final AuthController auth = Get.find<AuthController>();
    final LightController light = Get.find<LightController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: const Text(
          "Manage a group of lights",
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: const BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                "Existing Groups",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.03,
                ),
              ),
            ),
            Obx(() {
              if (auth.groups.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No Groups Found!"),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: auth.groups.length,
                  itemBuilder: (context, index) {
                    return CustomContainerTile(
                      text: auth.groups[index],
                      onTap: () {
                        //SETTING THE REFERENCE TO FETCH THE LED'S
                        light.updateControllerSection(auth.conId.value);
                        light.updateSection(auth.groups[index]);
                        light.updateTunnelBayReference();
                        light.fetchLEDData();
                        // light.controllerName.value = auth.conId.value;
                        // //SETTING THE TAPPED GROUP OR SECTION
                        // light.controllerName.value = auth.groups[index];
                        // Pass the group name to LightControl
                        // Get.to(() => AddingLight(
                        //     groupName: auth.groups[index].toString()));
                        //remove this after use and above one was the original
                        Get.to(() => const TwoButtonsScreen());
                        // Get.to(() => Mqtt(
                        //       groupName: auth.groups[index].toString(),
                        //     ));
                      },
                      onDelete: () async {
                        await auth.removeGroupFromFirestore(auth.groups[index]);
                      },
                    );
                  },
                );
              }
            }),
            // SizedBox(height: screenHeight * 0.02),
            // BeautifulButton(
            //   text: "Add a group",
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: const Text("Add Group"),
            //           content: TextField(
            //             controller: groupController,
            //             decoration: const InputDecoration(
            //               hintText: "Enter Group Name",
            //             ),
            //           ),
            //           actions: [
            //             TextButton(
            //               child: const Text('Cancel'),
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //             ),
            //             TextButton(
            //               child: const Text('Add'),
            //               onPressed: () async {
            //                 if (groupController.text.isNotEmpty) {
            //                   await auth
            //                       .addGroupToFirestore(groupController.text);
            //                   await auth.fetchGroupsFromFirestore();
            //                   Navigator.of(context).pop();
            //                 }
            //               },
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
