import 'dart:math';
import 'dart:typed_data';

import 'package:cryptool/viewmodel/services/cripto_service_aes.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopAesForm extends StatefulWidget {
  const DesktopAesForm({super.key});

  @override
  State<DesktopAesForm> createState() => _DesktopAesFormState();
}

class _DesktopAesFormState extends State<DesktopAesForm> {
  GetIt getIt = GetIt.instance;
  late CryptoServiceAes _cryptoServiceAes;

  final _formKey = GlobalKey<FormState>();


  final TextEditingController cleanTextController      = TextEditingController();
  final TextEditingController secretTextController     = TextEditingController();
  final TextEditingController keyController            = TextEditingController();
  Encrypted encrypted = Encrypted(Uint8List(2));

  @override
  void initState() {
    _cryptoServiceAes = getIt.get<CryptoServiceAes>();
    super.initState();
  }

  _handleEncrypt(){
    Encrypted secret = _cryptoServiceAes.encrypt(
        message: cleanTextController.text,
        secret: keyController.text
    );
    encrypted = secret;
    secretTextController.text = secret.base64;
  }

  _handleDecrypt(){
    String cleanText = _cryptoServiceAes.decrypt(
        encrypted: encrypted,
        secret: keyController.text
    );
    cleanTextController.text = cleanText;
  }

  _handleGenerateKey(){
    Random _rnd = Random();
    var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    String key = String.fromCharCodes(Iterable.generate(32, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    keyController.text = key;
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded( flex:2, child: Text("Texto claro" ,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 18
                        )
                    ),
                  )),
                  Expanded( flex:1, child: SizedBox()),
                  Expanded( flex:2, child: Text("Texto criptografado",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 18
                        )
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      maxLines: 8,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Insira seu texto",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8
                          )
                      ),
                      controller: cleanTextController,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _handleEncrypt();
                                },
                                label: Text("Criptografar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_double_arrow_right_rounded,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigoAccent,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6,),
                          Visibility(
                            child: SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton.icon(
                                onPressed: (){
                                  _handleDecrypt();
                                },
                                label: Text("Descriptografar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                icon: Icon(Icons.keyboard_double_arrow_left_rounded,
                                  color: Colors.white,
                                  textDirection: TextDirection.ltr,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigoAccent,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      maxLines: 8,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "O texto criptografado aparecerá aqui",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8
                          )
                      ),
                      controller: secretTextController,
                    ),
                  ),
                ],
              ),
              SizedBox( height: 32,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      maxLines: 1,
                      maxLength: 32,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Insira sua chave",
                      ),
                      controller: keyController,
                    ),
                  ),
                  SizedBox( width: 8,),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        _handleGenerateKey();
                      },
                      label: Text("Gerar nova chave",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      icon: Icon(
                        Icons.cached_rounded,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
