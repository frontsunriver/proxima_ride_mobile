import 'package:flutter/material.dart';
import 'package:proximaride_app/consts/font_sizes.dart';

class ShowRidePage extends StatelessWidget {
  const ShowRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Text("Hello",style: TextStyle(color: Colors.white, fontSize: fontSizeHero),),
    );
  }
}
