import 'package:flutter/material.dart';
import 'package:jsc_task2/utils/const_color.dart';

class RichTextWidget extends StatelessWidget {
  RichTextWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });
  String title;
  String subtitle;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 18,
              color: subColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: subtitle,
            style: TextStyle(color: subColor.withOpacity(0.7), fontSize: 16),
          ),
        ],
      ),
    );
  }
}
