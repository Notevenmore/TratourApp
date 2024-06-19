import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Category {
  final String text;
  final String src;
  final Color color;
  final int? width;
  final int? height;

  Category(
      {required this.text,
      required this.src,
      required this.color,
      this.width,
      this.height});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      text: json['text'],
      src: json['src'],
      color: Color(int.parse(json['color'])),
      width: json['width'],
      height: json['height'],
    );
  }
}
