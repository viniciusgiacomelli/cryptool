import 'package:cryptool/view/components/home_form.dart';
import 'package:cryptool/view/components/home_header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              HomeHeader(),
              HomeForm()
            ],
          ),
        ),
      ),
    );
  }

}
