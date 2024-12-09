import 'package:car_wash_light/view/screens/home/testing/first_button_screen.dart';
import 'package:car_wash_light/view/screens/home/testing/second_button_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TwoButtonsScreen extends StatelessWidget {
  const TwoButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B4332), // Dark green
              Color(0xFF2D6A4F), // Slightly lighter dark green
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.car_repair,
                        size: 60,
                        color: Colors.white70,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Car Wash Light',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Color(0xFF081C15), // Darker green for bottom panel
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton(
                      'Connect Offline',
                      Icons.wifi_off_outlined,
                      () => Get.to(() => const FirstButtonScreen()),
                    ),
                    SizedBox(height: 16),
                    _buildButton(
                      'Connect Online',
                      Icons.wifi_outlined,
                      () => Get.to(() => SecondButtonScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF40916C), // Medium dark green for buttons
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
