import 'package:cryptool/shared/components/dark_mode_button.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Row(
        children: [
          Icon(
            Icons.lock_clock_rounded,
            size: 64,
            color: Colors.purple,
          ),
          Text(
            "CrypTool",
            style: TextStyle(color: Colors.purple, fontSize: 52),
          ),
          SizedBox(
            width: 32,
          ),
          DarkModeButton(),
        ],
      ),
    );
  }
}
