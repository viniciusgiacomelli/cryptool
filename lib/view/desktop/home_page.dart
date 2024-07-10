import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/home_form.dart';
import 'components/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: HomeHeader(),
          bottom: const TabBar(
              tabs: [
                Tab( child: Text("AES", style: TextStyle(color: Colors.amber),),),
                Tab( text: "RSA",),
                Tab( text: "HASH",),
              ]
          ),
        ),
        body: TabBarView(
          children: [
            HomeForm(),
            HomeForm(),
            HomeForm(),
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
