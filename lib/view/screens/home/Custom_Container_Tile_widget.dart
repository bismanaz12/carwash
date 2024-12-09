import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_styling.dart';
import '../../widget/Custom_text_widget.dart';
import '../../widget/common_image_view_widget.dart';

class CustomContainerTile extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  CustomContainerTile({
    Key? key,
    required this.text,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  _CustomContainerTileState createState() => _CustomContainerTileState();
}

class _CustomContainerTileState extends State<CustomContainerTile>
    with SingleTickerProviderStateMixin {
  bool isToggleOn = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: w(context, 26), vertical: w(context, 10)),
            width: w(context, 157),
            height: h(context, 146),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(h(context, 20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isToggleOn ? kTertiaryColor.withOpacity(0.8) : Colors.white,
                  isToggleOn ? kSecondaryColor.withOpacity(0.8) : Colors.white,
                ],
              ),
              border: Border.all(
                color: Colors.black.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isToggleOn
                      ? kSecondaryColor.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (isToggleOn)
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                Padding(
                  padding: all(context, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonImageView(
                            height: 41,
                            width: 61,
                            fit: BoxFit.contain,
                          ),
                          Transform.scale(
                            scale: 1 + (_animation.value * 0.1),
                            child: FlutterSwitch(
                              width: 41,
                              height: 25,
                              toggleSize: w(context, 15),
                              value: isToggleOn,
                              toggleColor: kSecondaryColor,
                              padding: w(context, 4),
                              activeColor: kTertiaryColor,
                              inactiveColor: klightGreyColor,
                              onToggle: (bool value) {
                                setState(() {
                                  isToggleOn = value;
                                });
                                if (value) {
                                  _animationController.forward();
                                } else {
                                  _animationController.reverse();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CustomText(
                              text: widget.text,
                              size: 16.5,
                              weight: FontWeight.w700,
                              color: isToggleOn
                                  ? Colors.white
                                  : const Color(0xff8C8C8C),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
