import 'dart:typed_data';

import 'package:cryptool/viewmodel/services/cripto_service_aes.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhoneAesForm extends StatefulWidget {
  const PhoneAesForm({super.key});

  @override
  State<PhoneAesForm> createState() => _PhoneAesFormState();
}

class _PhoneAesFormState extends State<PhoneAesForm> {
  GetIt getIt = GetIt.instance;
  late CryptoServiceAes _cryptoServiceAes;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController cleanTextController      = TextEditingController();
  final TextEditingController secretTextController     = TextEditingController();
  final TextEditingController keyController  = TextEditingController();

  List<String> algorithms = <String>["512", "256"];
  late String _algorithm;
  Encrypted encrypted = Encrypted(Uint8List(2));

  @override
  void initState() {
    _cryptoServiceAes = getIt.get<CryptoServiceAes>();
    _algorithm = algorithms[0];
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
    String key = _cryptoServiceAes.generateKey();
    keyController.text = key;
  }

  Future<void> _dialogBuilder({
    required BuildContext context,
    required String title,
    required String content,
    required bool activeDownload,
    required String fileName,
    TextEditingController? field
  }){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              IconButton(
                icon: Icon(Icons.close_rounded, color: Colors.indigoAccent,),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
              child: Text(content)
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.download),
                label: Text("Baixar"),
                onPressed: activeDownload ?  (){
                  Navigator.of(context).pop();
                } : null,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete_forever),
              label: Text("Limpar"),
              onPressed: activeDownload ?  (){
                field?.text = "";
                Navigator.of(context).pop();
              } : null,
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
          padding:  EdgeInsets.all(16.0),
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
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8
                        )
                      ),
                      controller: cleanTextController,
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Seu texto criptografado aparecerá aqui",
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
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        _handleEncrypt();
                      },
                      child: Text("Critpografar", style: TextStyle(
                          color: Colors.white
                      ),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        _handleDecrypt();
                      },
                      child: Text("Descriptografar", style: TextStyle(
                          color: Colors.white
                      ),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      maxLines: 1,
                      maxLength: 32,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Chave secreta",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8
                          )
                      ),
                      controller: keyController,
                    ),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.cached_rounded, color: Colors.white,),
                      onPressed: (){
                        _handleGenerateKey();
                      },
                      label: Text("Gerar \n secret", style: TextStyle(
                          color: Colors.white
                      ),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
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
