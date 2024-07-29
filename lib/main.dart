import 'package:cryptool/shared/providers/config_provider.dart';
import 'package:cryptool/shared/theme.g.dart';
import 'package:cryptool/view/desktop/desktop_home_page.dart';
import 'package:cryptool/view/mini/mini_home_page.dart';
import 'package:cryptool/view/phone/phone_home_page.dart';
import 'package:cryptool/viewmodel/services/cripto_service_aes.dart';
import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:cryptool/viewmodel/services/crypto_service_hash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CryptoService()),
        ChangeNotifierProvider(create: (context) => CryptoServiceAes()),
        ChangeNotifierProvider(create: (context) => CryptoServiceHash()),
        ChangeNotifierProvider(
          create: (context) => ConfigProvider(
            isDarkMode: ThemeMode.system == ThemeMode.dark,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _handleScreen({required double width}) {
    switch (width) {
      case < 380:
        return MiniHomePage();
      case < 870:
        return PhoneHomePage();
      default:
        return HomePage();
    }
  }

  //TODO algum modo de subir msg criptografada na mobile_aes
  //TODO temas de cores e dark mode
  //TODO Hash criando mesmo com texto vazio
  //TODO Aes Sem avisos de texto claro vazio
  //TODO Quando RSA tenta descritpografar sem chave privada carregada, aparece null na lista antes da instruçao de carregar chave

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1600),
        child: MaterialApp(
            title: 'Cryptool Flutter',
            debugShowCheckedModeBanner: false,
            themeMode: context.watch<ConfigProvider>().isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: ThemeData(
              colorScheme: MaterialTheme.lightScheme(),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: MaterialTheme.darkScheme(),
              useMaterial3: true,
            ),
            home: _handleScreen(width: width)),
      ),
    );
  }
}
