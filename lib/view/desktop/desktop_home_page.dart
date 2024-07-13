import 'dart:ui';
import 'package:cryptool/view/desktop/forms/desktop_hash_form.dart';
import 'package:flutter/material.dart';
import 'forms/desktop_aes_form.dart';
import 'forms/desktop_rsa_form.dart';
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
                Tab(
                    child:Row(
                      children: [
                        Icon(Icons.private_connectivity_rounded,),
                        SizedBox( width: 6,),
                        Text("RSA", style:
                          TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold
                          )
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                ),
                Tab(
                    child:Row(
                      children: [
                        Icon(Icons.lock_reset_rounded),
                        SizedBox( width: 6,),
                        Text("AES", style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold
                        ))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                ),
                Tab(
                    child:Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox( width: 6,),
                        Text("HASH", style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold
                        ))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                ),
              ]
          ),
        ),
        body: TabBarView(
          children: [
            DesktopRsaForm(),
            DesktopAesForm(),
            DesktopHashForm(),
          ],
        ),
      )
    );
  }

}
