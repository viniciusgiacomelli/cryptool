import 'package:flutter/material.dart';

import 'components/phone_form.dart';

class PhoneHomePage extends StatelessWidget {
  const PhoneHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: PhoneForm()
      )
    );
  }
}
