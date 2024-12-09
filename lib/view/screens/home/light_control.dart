import 'package:flutter/material.dart';
import 'package:car_wash_light/constants/app_colors.dart';

class LightControl extends StatefulWidget {
  final String groupName;

  const LightControl({Key? key, required this.groupName}) : super(key: key);

  @override
  _LightControlState createState() => _LightControlState();
}

class _LightControlState extends State<LightControl> {
  bool isLightOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: Text(
          "Control ${widget.groupName}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Group: ${widget.groupName}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Switch(
              value: isLightOn,
              onChanged: (value) {
                setState(() {
                  isLightOn = value;
                });
                // TODO: Implement logic to control the lights
              },
              activeColor: darkGreen,
            ),
            Text(
              isLightOn ? "Lights are ON" : "Lights are OFF",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement additional control features
              },
              child: Text("More Controls"),
            )
          ],
        ),
      ),
    );
  }
}
