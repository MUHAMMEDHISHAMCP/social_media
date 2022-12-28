import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    this.color = Colors.black,
    this.weight = FontWeight.w200,
    this.overflow = TextOverflow.ellipsis,
    this.lines = 1,
    this.align = TextAlign.center,
    this.spacing = 0
    
  }) : super(key: key);
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight  weight;
  final TextOverflow overflow;
  final int lines;
  final TextAlign align;
  final double spacing;
  @override
  Widget build(BuildContext context) {
    return  Text(
      text,
      style:  TextStyle(
      //  fontFamily: 'MainFont',
        fontSize: fontSize,
        color: color,
        fontWeight: weight,
        letterSpacing: spacing
        
      ),
      textAlign: align,
      overflow: overflow,
      maxLines:lines ,
    );
  }
}