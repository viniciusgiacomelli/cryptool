import 'package:cryptool/view/desktop/forms/desktop_hash_form.dart';
import 'package:flutter/material.dart';

import 'forms/desktop_aes_form.dart';
import 'forms/home_form.dart';
import '../global/components/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: HomeHeader(),
          bottom: const TabBar(
              tabs: [
                Tab( child: Text("RSA", style: TextStyle(color: Colors.amber),),),
                Tab( text: "AES",),
                Tab( text: "HASH",),
              ]
          ),
        ),
        body: TabBarView(
          children: [
            HomeForm(),
            DesktopAesForm(),
            DesktopHashForm(),
          ],
        ),
        // body: SingleChildScrollView(
        //   child: Container(
        //     child: Column(
        //       children: [
        //         HomeForm()
        //       ],
        //     ),
        //   ),
        // )
      )
    );
  }

}
