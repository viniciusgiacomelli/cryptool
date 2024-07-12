import 'package:cryptool/view/phone/components/decrypt_phone_form.dart';
import 'package:flutter/material.dart';

import '../global/components/home_header.dart';
import 'components/phone_form.dart';

class PhoneHomePage extends StatefulWidget {
  const PhoneHomePage({super.key});

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
              icon: Icon(Icons.lock,),
              label: 'Criptografar'
          ),
          NavigationDestination(
              icon: Icon(Icons.lock_open),
              label: 'Descriptografar'
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(),
              <Widget>[
                PhoneForm(),
                DecryptPhoneForm()
              ][currentPageIndex]
            ],
          )
          // child: <Widget>[
          //   PhoneForm(),
          //   DecryptPhoneForm()
          // ][currentPageIndex]
      )
    );
  }
}
