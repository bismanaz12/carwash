import 'package:car_wash_light/core/utils/firebase/firebase_references.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../model/led_model.dart';

class LightController extends GetxController {
  late DatabaseReference tunnelBayTest; // Use a regular DatabaseReference
  late DatabaseReference controllerReference;
  late DatabaseReference iba;
  var tunnelName = "".obs;
  var controllerName = "".obs;
  var toggle = false.obs;
  var deviceId = "".obs;
  //THIS IS THE COMPLETE REFERENCE USED FOR ADDING THE LIGHT--THIS IS USED IN THE ADDINGLIGHTS DART FILE
  var completeRefrence = "".obs;
  var ssid = "".obs;
  var password = "".obs;
  var mdns = "".obs;

  // MY CREATIVITY
  var toggleStates = <String, bool>{}.obs;
  LightController() {
    // Initialize the DatabaseReference here, after the object is created
    updateTunnelBayReference();
    // updateControllerBayReference();

    // Listen to changes in tunnelName and update the reference
    ever(tunnelName, (_) => updateTunnelBayReference());
    ever(controllerName, (_) => updateTunnelBayReference());
  }
  @override
  void onInit() {
    super.onInit();
    fetchSectionData();
  }

//MY CREATIVITY FOR USING THE TOGGLE BUTTON
  void toggleLight(String id) {
    toggleStates[id] = !(toggleStates[id] ?? false); // Toggle the state
  }

  void setMdns(String Mdns) {
    mdns.value = Mdns;
  }

  void updateTunnelBayReference() {
    tunnelBayTest = FirebaseDatabase.instance
        .ref()
        .child('con/${controllerName.value}/${tunnelName.value}');
    //ADDING LIGHTS VARIABLE USED FOR THE REFERENCE OF THE ADDINGLIGHTS
    // completeRefrence.value = 'con/${controllerName}/${tunnelName.value}';
  }

  void updateLightReference(String lightName) {
    completeRefrence.value =
        'con/${controllerName}/${tunnelName.value}/${lightName}';
  }

  void updateSection(String section) {
    tunnelName.value = section;
  }

//ADDING SSID AND PASSWORD
  void setSsid(String ssId) {
    ssid.value = ssId;
  }

  void setPassword(String Password) {
    password.value = Password;
  }

  void updateControllerSection(String controller) {
    controllerName.value = controller;
    fetchSectionData();
  }

  void setDeviceIp(String ip) {
    deviceId.value = ip;
  }

  RxList<LedModel> lightForATunnel = <LedModel>[].obs;

  Future<List<LedModel>> fetchLEDData() async {
    print(tunnelBayTest.path);
    print("in fetch led function");
    print(lightForATunnel);
    lightForATunnel.clear();
    print(lightForATunnel);

    DataSnapshot snapshot = await tunnelBayTest.get(); // Correct reference
    List<LedModel> leds = [];

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          leds.add(LedModel.fromJson(Map<String, dynamic>.from(value)));
        } else {
          print('Unexpected value type: ${value.runtimeType}'); // For debugging
        }
      });
    }

    lightForATunnel.value = leds;
    return lightForATunnel;
  }

  //ADDING LIGHT CONTROLLER METHOD FOR DYNAMICALLY ADDING CONTROLLERS
  var ledData = <String, dynamic>{}.obs;
  var bayNames = <String>[].obs;

  Future<void> fetchSectionData() async {
    bayNames.clear();

    try {
      DataSnapshot snapshot = await FirebaseDatabase.instance
          .ref("con/${controllerName.value}")
          .get();
      if (snapshot.exists) {
        ledData.value = Map<String, dynamic>.from(snapshot.value as Map);

        bayNames.value = ledData.keys.toList();
        print("HERE ARE THE KEYS ONLY :${bayNames}");
      } else {
        print("no data available!");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //ABOVE METHOD ENDS HERE

  Future<void> updateLEDState(String ledId, String newState) async {
    await tunnelBayTest.child(ledId).update({'state': newState});
  }

  Future<void> updateLEDColor(String ledId, String newColor) async {
    await tunnelBayTest.child(ledId).update({'color': newColor});
  }
}
