import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.lock_clock_rounded, size: 64, color: Colors.purple,),
        Text("CrypTool", style: TextStyle(color: Colors.purple, fontSize: 52),),
        SizedBox(width: 200,),
        Text("Simétrico"),
        Text("Assimétrico"),
      ],
    );
  }
}
