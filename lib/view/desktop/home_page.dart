import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/home_form.dart';
import 'components/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(),
            HomeForm()
          ],
        ),
      )
    );
  }

}
