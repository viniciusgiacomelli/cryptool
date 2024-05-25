import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class DecryptPhoneForm extends StatefulWidget {
  const DecryptPhoneForm({super.key});

  @override
  State<DecryptPhoneForm> createState() => _DecryptPhoneFormState();
}

class _DecryptPhoneFormState extends State<DecryptPhoneForm> {
  GetIt getIt = GetIt.instance;
  late CryptoService _cryptoService;

  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _privateKey = false;

  @override
  void initState() {
    _cryptoService = getIt.get<CryptoService>();
    super.initState();
  }

  Future<void> _dialogBuilder({
    required BuildContext context,
    required String title,
    required String content,
    required bool activeDownload,
    required String fileName,
    TextEditingController? field
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(content)),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text("Baixar"),
              onPressed: activeDownload ?  (){
                _cryptoService.save(
                    content: content,
                    type: fileName
                );
                Navigator.of(context).pop();
              } : null,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete_forever, color: Colors.redAccent,),
              label: Text("Limpar"),
              onPressed: activeDownload ?  (){
                field?.text = "";
                if(field == privateKeyTextController){
                  setState(() {
                    _privateKey = false;

                  });
                }
                Navigator.of(context).pop();
              } : null,
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _handleDecrypt() async {
    String? errors;
    if(secretTextController.text == ""){
      errors = "- Cole o texto secreto para decrifrar \n";
    }
    if(!_privateKey){
      errors = "$errors - Carregue uma chave privada";
    }
    if(errors != null){
      _dialogBuilder(
          context: context,
          title: "Atenção",
          content: errors,
          activeDownload: false,
          fileName: ""
      );
    } else {
      var cleanText = await _cryptoService.decryptPKCS(
          secret: secretTextController.text,
          privateKey: privateKeyTextController.text
      );
      if(cleanText != null){
        cleanTextController.text = cleanText;
      } else{
        _dialogBuilder(
            context: context,
            title: "Erro",
            content: "Erro ao descriptogarafar",
            activeDownload: false,
            fileName: "Verifique a chave e o texto enviados e tente novamente"
        );
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Texto criptografado",
                        hintText: "Insira o texto secreto",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8
                        )
                      ),
                      controller: secretTextController,
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: TextFormField(
                      onTap: (){
                        _dialogBuilder(
                            context: context,
                            title: "Texto claro",
                            content: cleanTextController.text != "" ?
                            cleanTextController.text :
                            "Seu texto claro aparecerá aqui",
                            activeDownload: cleanTextController.text != "",
                            fileName: "clear_text",
                          field: cleanTextController
                        );
                      },
                      readOnly: true,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Texto claro",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8
                        )
                      ),
                      controller: cleanTextController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.upload, size: 20,),
                      label: Text("Carregar ... "),
                      onPressed: () async {
                        String? secretText = await _cryptoService.uploadFile();
                        if(secretText != null){
                          setState(() {
                            secretTextController.text = secretText;
                          });
                        }
                      },
                    )
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: (){
                            _handleDecrypt();
                          },
                          child: Text("Descriptografar")
                      ),
                  )
                ],
              ),
              SizedBox(height: 8,),
              Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        _dialogBuilder(
                            context: context,
                            title: _privateKey ? "Chave privada" : "Carregue uma chave",
                          content: privateKeyTextController.text,
                          activeDownload: _privateKey,
                          fileName: "private_key",
                          field: privateKeyTextController
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Column(
                          children: [
                            Text("Chave privada"),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0
                                ),
                              ),
                              child: Center(
                                child: _privateKey ?
                                Icon( Icons.key_rounded, size: 80,) :
                                Icon( Icons.key_rounded, size: 80, color: Colors.black26),
                              ),
                            ),
                            Text( _privateKey ? "Clique para abrir" : "Carregue uma chave", style: TextStyle(fontSize: 10),),
                          ],
                        ),
                      )
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.upload, size: 20,),
                    label: Text("Carregar ... "),
                    onPressed: () async {
                      String? publicKey = await _cryptoService.uploadFile();
                      if(publicKey != null){
                        setState(() {
                          privateKeyTextController.text = publicKey;
                          _privateKey = true;
                        });
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
}
