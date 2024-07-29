import 'dart:typed_data';

import 'package:cryptool/viewmodel/services/cripto_service_aes.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneAesForm extends StatefulWidget {
  const PhoneAesForm({super.key});

  @override
  State<PhoneAesForm> createState() => _PhoneAesFormState();
}

class _PhoneAesFormState extends State<PhoneAesForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController keyController = TextEditingController();

  List<String> algorithms = <String>["256", "192", "128"];
  late String _algorithm;
  late int _length;
  Encrypted encrypted = Encrypted(Uint8List(2));

  @override
  void initState() {
    _algorithm = algorithms[0];
    _length = 32;
    super.initState();
  }

  _handleEncrypt() {
    Encrypted secret = context
        .read<CryptoServiceAes>()
        .encrypt(message: cleanTextController.text, secret: keyController.text);
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
      cleanTextController.text = "";
      secretTextController.text = "";
      keyController.text = "";
    });
  }

  Future<void> _dialogBuilder(
      {required BuildContext context,
      required String title,
      required String content,
      required bool activeDownload,
      required String fileName,
      TextEditingController? field}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.indigoAccent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(child: Text(content)),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text("Baixar"),
              onPressed: activeDownload
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : null,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete_forever),
              label: Text("Limpar"),
              onPressed: activeDownload
                  ? () {
                      field?.text = "";
                      Navigator.of(context).pop();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Text("Texto claro")),
                Expanded(child: Text("Texto criptografado"))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: 6,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Insira seu texto",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    controller: cleanTextController,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      _dialogBuilder(
                          context: context,
                          title: "Texto criptografado",
                          content: secretTextController.text != ""
                              ? secretTextController.text
                              : "Seu texto criptografado aparecerá aqui",
                          activeDownload: secretTextController.text != "",
                          fileName: "aes_secret_text",
                          field: secretTextController);
                    },
                    readOnly: true,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Seu texto criptografado aparecerá aqui",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    controller: secretTextController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _handleEncrypt();
                    },
                    child: Text(
                      "Critpografar",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _handleDecrypt();
                    },
                    child: Text(
                      "Descriptografar",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    maxLines: 1,
                    maxLength: _length,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Chave secreta",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    controller: keyController,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.cached_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _handleGenerateKey();
                    },
                    label: Text(
                      "Gerar secret",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
