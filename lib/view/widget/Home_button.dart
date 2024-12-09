import 'package:car_wash_light/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BeautifulButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final EdgeInsets padding;

  const BeautifulButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 20.0,
    this.fontSize = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: darkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        elevation: 5,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
