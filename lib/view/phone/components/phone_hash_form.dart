import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhoneHashForm extends StatefulWidget {
  const PhoneHashForm({super.key});

  @override
  State<PhoneHashForm> createState() => _PhoneHashFormState();
}

class _PhoneHashFormState extends State<PhoneHashForm> {
  GetIt getIt = GetIt.instance;
  late CryptoService _cryptoService;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController cleanTextController      = TextEditingController();
  final TextEditingController secretTextController     = TextEditingController();
  final TextEditingController publicKeyTextController  = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();

  List<String> algorithms = <String>["512", "256"];
  late String _algorithm;
  bool _publicKey = false;
  bool _privateKey = false;
  bool _generating = false;

  @override
  void initState() {
    _cryptoService = getIt.get<CryptoService>();
    _algorithm = algorithms[0];
    super.initState();
  }

  Future<String?> _generateKeyPair() async {
    setState(() {
      _generating = true;
    });
    KeyPair keyPair = await _cryptoService.generateKeryPair();
    setState(() {
      privateKeyTextController.text = keyPair.privateKey;
      publicKeyTextController.text = keyPair.publicKey;
      _privateKey = true;
      _publicKey = true;
      _generating = false;
    });
    return null;
  }

  Future<bool> _handleUpload({
    required TextEditingController controller,
    required String field
  }) async {
    String? publicKey = await _cryptoService.uploadFile();
    if(publicKey != null){
      setState(() {
        controller.text = publicKey;
        if(field == "private"){
          _privateKey = true;
        } else {
          _publicKey = true;
        }
      });
      return true;
    } return false;
  }

  Future<String> _getPublicKey() async {
    if(publicKeyTextController.text == ""){
      await _generateKeyPair();
      return publicKeyTextController.text;
    }
    return publicKeyTextController.text;
  }

  Future<bool> _applyCriptography() async {
    if(cleanTextController.text == ""){
      _dialogBuilder(
          context: context,
          title: "Atenção",
          content: "Escreva um texto para ser criptografado",
          activeDownload: false,
          fileName: ""
      );
    } else {
      var publicKey = await _getPublicKey();
      var secret = await _cryptoService.cryptograph(
          message: cleanTextController.text,
          publicKey: _algorithm == "RSA" ? publicKey : null
      );
      if(secret != null){
        secretTextController.text = secret;
        return true;
      }
    }
    return false;
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
                  _cryptoService.save(
                      content: content,
                      type: fileName
                  );
                  Navigator.of(context).pop();
                } : null,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete_forever),
              label: Text("Limpar"),
              onPressed: activeDownload ?  (){
                field?.text = "";
                if(field == privateKeyTextController){
                  setState(() {
                    _privateKey = false;
                  });
                } else if(field == publicKeyTextController){
                  setState(() {
                    _publicKey = false;
                  });
                }
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
                      onTap: (){
                        _dialogBuilder(
                          context: context,
                          title: _algorithm == "RSA" ? "Texto criptografado" : "Hash",
                          content: secretTextController.text != "" ?
                            secretTextController.text :
                            "Seu texto criptografado aparecerá aqui",
                          activeDownload: secretTextController.text != "",
                          fileName: _algorithm == "RSA" ? "secret_text" : "hash",
                          field: secretTextController
                        );
                      },
                      readOnly: true,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DropdownButton(
                      iconSize: 40.0,
                      isExpanded: true,
                      isDense: true,
                      iconEnabledColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      borderRadius: BorderRadius.circular(10),
                      items: algorithms.map<DropdownMenuItem<String>>((String? brandValue) =>
                          DropdownMenuItem<String>(
                              value:brandValue,
                              child: Text("$brandValue")
                          )
                      ).toList(),
                      value: _algorithm,
                      onChanged: (String? brandValue){
                        setState(() {
                          _algorithm = brandValue!;
                          cleanTextController.text = "";
                          secretTextController.text = "";
                        });
                      },
                    ),
                  ),
                  SizedBox( width: 12,),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            var applied = await _applyCriptography();
                          }
                        },
                        child: Text("Aplicar", style: TextStyle(
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
