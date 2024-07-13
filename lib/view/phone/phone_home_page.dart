import 'package:cryptool/view/phone/components/phone_aes_form.dart';
import 'package:cryptool/view/phone/components/phone_hash_form.dart';
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
              icon: Icon(Icons.private_connectivity_rounded,),
              label: 'RSA'
          ),
          NavigationDestination(
              icon: Icon(Icons.lock_reset_rounded),
              label: 'AES'
          ),
          NavigationDestination(
              icon: Icon(Icons.lock),
              label: 'Hash'
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(),
            <Widget>[
              PhoneForm(),
              PhoneAesForm(),
              PhoneHashForm(),
            ][currentPageIndex]
          ],
        )
      )
    );
  }
}
