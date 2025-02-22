import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      required this.text,
      this.fontSize = 14,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black,
      this.textAlign,
      this.overflow,
      this.onTap,
      this.textDecoration,
      this.letterSpacing,
      this.fontStyle});
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onTap;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        style: TextStyle(
            color: color,
            decoration: textDecoration,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: "satoshi",
            fontStyle: fontStyle,
            letterSpacing: letterSpacing),
      ),
    );
  }
}
