import 'dart:typed_data';

import 'package:cryptool/viewmodel/services/cripto_service_aes.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DesktopAesForm extends StatefulWidget {
  const DesktopAesForm({super.key});

  @override
  State<DesktopAesForm> createState() => _DesktopAesFormState();
}

class _DesktopAesFormState extends State<DesktopAesForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  Encrypted encrypted = Encrypted(Uint8List(2));
  List<String> algorithms = <String>["256", "192", "128"];
  late String _algorithm;
  late int _length;

  @override
  void initState() {
    _algorithm = algorithms[0];
    _length = 32;
    super.initState();
  }

  _handleEncrypt() {
    if (cleanTextController.text == "") {
      _dialogBuilder(
          context: context, content: "Insira um texto para ser criptografado");
    } else if (keyController.text == "") {
      _dialogBuilder(
          context: context,
          content: "Insira ou gere uma chave para criptografar o texto");
    }
    Encrypted secret = context.read<CryptoServiceAes>().encrypt(
          message: cleanTextController.text,
          secret: keyController.text,
        );
    encrypted = secret;
    secretTextController.text = secret.base64;
  }

  _handleDecrypt() {
    String cleanText = context
        .read<CryptoServiceAes>()
        .decrypt(encrypted: encrypted, secret: keyController.text);
    cleanTextController.text = cleanText;
  }

  _handleGenerateKey() {
    String key = context.read<CryptoServiceAes>().generateKey(length: _length);
    keyController.text = key;
  }

  _handleChangeLength(String? algorithm) {
    int length = 32;
    switch (algorithm) {
      case "256":
        length = 32;
      case "192":
        length = 24;
      case "128":
        length = 16;
    }
    setState(() {
      _algorithm = algorithm!;
      _length = length;
      secretTextController.text = "";
      keyController.text = "";
    });
  }

  Future<void> _dialogBuilder(
      {required BuildContext context,
      required String content,
      TextEditingController? field}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Atençao!"),
              IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded))
            ],
          ),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.close_rounded,  color: Colors.indigoAccent),
          //     onPressed: (){
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
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
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Texto claro",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(fontSize: 18)),
                      )),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Texto criptografado",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(fontSize: 18)),
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
                              vertical: 12, horizontal: 8)),
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
                                label: Text(
                                  "Criptografar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                icon: Icon(
                                  Icons.keyboard_double_arrow_right_rounded,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigoAccent,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Visibility(
                            child: SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _handleDecrypt();
                                },
                                label: Text(
                                  "Descriptografar",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                icon: Icon(
                                  Icons.keyboard_double_arrow_left_rounded,
                                  color: Colors.white,
                                  textDirection: TextDirection.ltr,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigoAccent,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
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
                              vertical: 12, horizontal: 8)),
                      controller: secretTextController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: DropdownButton(
                      iconSize: 40.0,
                      isExpanded: true,
                      isDense: true,
                      iconEnabledColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      borderRadius: BorderRadius.circular(10),
                      items: algorithms
                          .map<DropdownMenuItem<String>>((String? algorithm) =>
                              DropdownMenuItem<String>(
                                  value: algorithm,
                                  child: Text("Chave $algorithm bits")))
                          .toList(),
                      value: _algorithm,
                      onChanged: (String? algorithm) {
                        _handleChangeLength(algorithm);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      maxLines: 1,
                      maxLength: _length,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Insira sua chave",
                      ),
                      controller: keyController,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        _handleGenerateKey();
                      },
                      label: Text(
                        "Gerar nova chave",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.cached_rounded,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
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
