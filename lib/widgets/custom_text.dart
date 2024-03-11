import 'package:flutter/material.dart';


class ParagraphText extends StatelessWidget {
  final  TextOverflow? overflow;
  final String text;
  final Color? color;
  final double? fontSize;
  final int? maxline;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final bool underlined;
  final double? lineHeight;
  final FontStyle? fontStyle;
  const ParagraphText(this.text,{
    Key? key,

    this.color,
    this.fontSize,
    this.maxline,
    this.fontWeight,
    this.fontFamily='poppins',
    this.textAlign,
    this.underlined = false,
    this.lineHeight,
    this.fontStyle,
    this.overflow
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: overflow,
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxline,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize ?? 16,
        height: lineHeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: underlined ? TextDecoration.underline : null,
      ),
    );
  }
}

