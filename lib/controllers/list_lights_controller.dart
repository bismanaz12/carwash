import 'package:car_wash_light/model/led_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ListLightController extends GetxController {
  late DatabaseReference controllerReference;
  var controllerName = ''.obs;
  var toggleStates = <String, bool>{}.obs;
  var lightForAllGroups = <String, RxList<LedModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    ever(controllerName, (_) => fetchAllGroupsData());
  }

  void updateControllerSection(String controller) {
    controllerName.value = controller;
  }

  void toggleLight(String groupName, String id) async {
    String compositeKey = '$groupName-$id';
    bool newState = !(toggleStates[compositeKey] ?? false);
    toggleStates[compositeKey] = newState;

    String newBrightness = newState ? '255' : '00';
    String state = newState ? 'on' : 'off';

    await updateLEDState(groupName, id, state, newBrightness);
  }

  Future<void> fetchAllGroupsData() async {
    if (controllerName.value.isEmpty) return;

    DatabaseReference controllerRef =
        FirebaseDatabase.instance.ref().child('con/${controllerName.value}');

    try {
      DataSnapshot snapshot = await controllerRef.get();

      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> groupsData =
            snapshot.value as Map<dynamic, dynamic>;
        lightForAllGroups.clear(); // Clear existing data before updating

        groupsData.forEach((groupName, groupData) {
          if (groupData is Map) {
            RxList<LedModel> groupLights = <LedModel>[].obs;
            groupData.forEach((ledId, ledData) {
              if (ledData is Map) {
                groupLights.add(LedModel(
                  id: ledId.toString(),
                  brightness: ledData['brightness']?.toString() ?? '00',
                  color: ledData['color']?.toString() ?? '#FFFFFF',
                  name: ledData['name']?.toString() ?? 'Unknown',
                  state: ledData['state']?.toString() ?? 'off',
                ));
                // Initialize toggle states
                toggleStates['$groupName-$ledId'] = ledData['state'] == 'on';
              }
            });
            lightForAllGroups[groupName.toString()] = groupLights;
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    update(); // Notify listeners that data has changed
  }

  Future<void> updateLEDState(
      String groupName, String ledId, String state, String brightness) async {
    DatabaseReference ledRef = FirebaseDatabase.instance
        .ref()
        .child('con/${controllerName.value}/$groupName/$ledId');
    await ledRef.update({'state': state, 'brightness': brightness});
    await fetchAllGroupsData(); // Refresh data after update
  }

  Future<void> updateLEDColor(
      String groupName, String ledId, String color) async {
    DatabaseReference ledRef = FirebaseDatabase.instance
        .ref()
        .child('con/${controllerName.value}/$groupName/$ledId');
    await ledRef.update({'color': color});
    await fetchAllGroupsData(); // Refresh data after update
  }
}
