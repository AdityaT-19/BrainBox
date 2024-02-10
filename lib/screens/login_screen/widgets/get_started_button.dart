import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStartedButton extends StatefulWidget {
  final Function onTap;
  final Function onAnimatinoEnd;
  final double elementsOpacity;
  const GetStartedButton(
      {super.key,
      required this.onTap,
      required this.onAnimatinoEnd,
      required this.elementsOpacity});

  @override
  State<GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300),
      tween: Tween(begin: 1, end: widget.elementsOpacity),
      onEnd: () async {
        widget.onAnimatinoEnd();
      },
      builder: (_, value, __) => GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Opacity(
          opacity: value,
          child: Container(
            width: 230,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.theme.colorScheme.primaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Get Started",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Get.theme.colorScheme.onPrimaryContainer,
                      fontSize: 19),
                ),
                SizedBox(width: 15),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Get.theme.colorScheme.onPrimaryContainer,
                  size: 26,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
