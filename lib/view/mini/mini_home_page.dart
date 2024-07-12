import 'package:cryptool/view/mini/components/mini_decrypt_phone_form.dart';
import 'package:flutter/material.dart';

import '../global/components/home_header.dart';
import 'components/mini_phone_form.dart';

class MiniHomePage extends StatefulWidget {
  const MiniHomePage({super.key});

  @override
  State<MiniHomePage> createState() => _MiniHomePageState();
}

class _MiniHomePageState extends State<MiniHomePage> {

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
                MiniForm(),
                MiniDecryptForm()
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
