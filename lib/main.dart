import 'package:cryptool/view/desktop/home_page.dart';
import 'package:cryptool/view/mini/mini_home_page.dart';
import 'package:cryptool/view/phone/phone_home_page.dart';
import 'package:cryptool/viewmodel/services/cripto_service_aes.dart';
import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:cryptool/viewmodel/services/crypto_service_hash.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt getIt = GetIt.instance;
  getIt.registerLazySingleton<CryptoServiceAes>(() => CryptoServiceAes());
  getIt.registerLazySingleton<CryptoService>(() => CryptoService());
  getIt.registerLazySingleton<CryptoServiceHash>(() => CryptoServiceHash());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _handleScreen({ required double width}){
    switch(width){
      case < 380:
        return MiniHomePage();
      case < 870 :
        return PhoneHomePage();
      default:
        return HomePage();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Cryptool Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _handleScreen(width: width)
      );
  }
}

