import 'package:flutter/material.dart';
import 'package:voice_assistant/property/color_packet.dart';

class Myfeaturelist extends StatelessWidget {
  final Color color;
  final String heading;
  final String description;
  const Myfeaturelist({super.key, required this.color, required this.heading, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0).copyWith(
          left: 15,
          right: 15
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                heading,
                style:const TextStyle(
                    fontFamily: 'karla',
                    color: Pallete.mainFontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                    ),
              ),
            ),
            Text(
              description,
              style:const TextStyle(
                  fontFamily: 'karla',
                  color: Pallete.mainFontColor,
                  fontSize: 15
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
